local M = {}

local securityContext = {
    runAsUser = 70,
    runAsGroup = 70,
}

local resources = {
    limits = {
        cpu = '8',
        memory = '16Gi',
    },
    requests = {
        cpu = '4',
        memory = '8Gi',
    },
}

local initContainer = function(image)
    return {
        name = 'init-db',
        image = image.fullRef,
        env = {
            { name = 'PGDATA', value = '/var/lib/postgresql/data/pgdata' },
        },
        command = { 'init-entrypoint.sh' },
        volumeMounts = {
            { name = 'disk',                mountPath = '/var/lib/postgresql/data' },
            { name = 'central-db-password', mountPath = '/run/secrets/stackrox.io/secrets' },
        },
        resources = resources,
        securityContext = securityContext,
    }
end

local container = function(image)
    return {
        name = 'central-db',
        image = image.fullRef,
        env = {
            { name = 'POSTGRES_HOST_AUTH_METHOD', value = 'password' },
            { name = 'PGDATA',                    value = '/var/lib/postgresql/data/pgdata' },
        },
        ports = { { containerPort = 5432, name = 'postgresql', protocol = 'TCP' } },
        readinessProbe = {
            exec = {
                command = {
                    '/bin/sh',
                    '-c',
                    '-e',
                    'exec pg_isready -U "postgresql" -h 127.0.0.1 -p 5432',
                },
            },
            failureThreshold = 3,
            periodSeconds = 10,
            successThreshold = 1,
            timeoutSeconds = 1,
        },
        resources = resources,
        securityContext = securityContext,
        volumeMounts = {
            { name = 'config-volume',         mountPath = '/etc/stackrox.d/config' },
            { name = 'disk',                  mountPath = '/var/lib/postgresql/data' },
            { name = 'central-db-tls-volume', mountPath = '/run/secrets/stackrox.io/certs' },
            { name = 'shared-memory',         mountPath = '/dev/shm' },
        },
    }
end

local volumes = {
    { name = 'disk',                emptyDir = {} },
    { name = 'config-volume',       configMap = { name = 'central-db-config' } },
    { name = 'central-db-password', secret = { secretName = 'central-db-password' } },
    {
        name = 'central-db-tls-volume',
        secret = {
            secretName = 'central-db-tls',
            defaultMode = 416, -- 0640
            items = {
                { key = 'cert.pem', path = 'server.crt' },
                { key = 'key.pem',  path = 'server.key' },
                { key = 'ca.pem',   path = 'root.crt' },
            },
        }
    },
    { name = 'shared-memory', emptyDir = { medium = 'Memory', sizeLimit = '2Gi' } },
}

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'apps/v1',
        kind = 'Deployment',
        metadata = {
            name = 'central-db',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        spec = {
            replicas = 1,
            minReadySeconds = 15,
            selector = { matchLabels = { app = 'central-db' } },
            strategy = { type = 'Recreate' },
            template = {
                metadata = {
                    namespace = 'stackrox',
                    labels = { app = 'central-db' },
                },
                spec = {
                    affinity = require('central-affinity'),
                    serviceAccountName = 'central-db',
                    terminationGracePeriodSeconds = 120,
                    initContainers = { initContainer(o.image) },
                    containers = { container(o.image) },
                    securityContext = { fsGroup = 70 },
                    volumes = volumes,
                },
            },
        },
    }
end

return M
