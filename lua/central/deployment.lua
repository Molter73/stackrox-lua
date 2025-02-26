local M = {}

local env = {
    {
        name = 'ROX_MEMLIMIT',
        valueFrom = { resourceFieldRef = { resource = 'limits.memory' } },
    },
    {
        name = 'GOMAXPROCS',
        valueFrom = { resourceFieldRef = { resource = 'limits.cpu' } },
    },
    {
        name = 'POD_NAMESPACE',
        valueFrom = { fieldRef = { fieldPath = 'metadata.namespace' } },
    },
    { name = 'ROX_TELEMETRY_STORAGE_KEY_V1',  value = 'DISABLED' },
    { name = 'ROX_OFFLINE_MODE',              value = 'false' },
    { name = 'ROX_INSTALL_METHOD',            value = 'manifest' },
    { name = 'ROX_DECLARATIVE_CONFIGURATION', value = 'true' },
    { name = 'ROX_DEVELOPMENT_BUILD',         value = 'true' },
    { name = 'ROX_HOTRELOAD',                 value = 'false' },
    { name = 'ROX_MANAGED_CENTRAL',           value = 'false' },
    { name = 'ROX_NETWORK_ACCESS_LOG',        value = 'false' },
}

local volumeMounts = {
    { name = 'varlog',                     mountPath = '/var/log/stackrox/' },
    { name = 'central-tmp-volume',         mountPath = '/tmp' },
    { name = 'central-etc-ssl-volume',     mountPath = '/etc/ssl' },
    { name = 'central-etc-pki-volume',     mountPath = '/etc/pki/ca-trust' },
    { name = 'central-db-password',        mountPath = '/run/secrets/stackrox.io/db-password' },
    { name = 'central-external-db-volume', mountPath = '/etc/ext-db' },
    {
        name = 'central-certs-volume',
        mountPath = '/run/secrets/stackrox.io/certs/',
        readOnly = true
    },
    {
        name = 'central-default-tls-cert-volume',
        mountPath = '/run/secrets/stackrox.io/default-tls-cert/',
        readOnly = true
    },
    {
        name = 'central-htpasswd-volume',
        mountPath = '/run/secrets/stackrox.io/htpasswd/',
        readOnly = true
    },
    {
        name = 'central-jwt-volume',
        mountPath = '/run/secrets/stackrox.io/jwt/',
        readOnly = true
    },
    {
        name = 'additional-ca-volume',
        mountPath = '/usr/local/share/ca-certificates/',
        readOnly = true
    },
    {
        name = 'central-license-volume',
        mountPath = '/run/secrets/stackrox.io/central-license/',
        readOnly = true
    },
    --{ name = 'stackrox-db',           mountPath = '/var/lib/stackrox' },
    { name = 'central-config-volume', mountPath = '/etc/stackrox' },
    {
        name = 'proxy-config-volume',
        mountPath = '/run/secrets/stackrox.io/proxy-config/',
        readOnly = true
    },
    {
        name = 'endpoints-config-volume',
        mountPath = '/etc/stackrox.d/endpoints/',
        readOnly = true
    },
    {
        name = 'declarative-configurations',
        mountPath = '/run/stackrox.io/declarative-configuration/declarative-configurations',
        readOnly = true,
    },
    {
        name = 'sensitive-declarative-configurations',
        mountPath = '/run/stackrox.io/declarative-configuration/sensitive-declarative-configurations',
        readOnly = true,
    },
}

local volumes = {
    { name = 'varlog',                 emptyDir = {} },
    { name = 'central-tmp-volume',     emptyDir = {} },
    { name = 'central-etc-ssl-volume', emptyDir = {} },
    { name = 'central-etc-pki-volume', emptyDir = {} },
    { name = 'central-certs-volume',   secret = { secretName = 'central-tls' } },
    {
        name = 'central-default-tls-cert-volume',
        secret = { secretName = 'central-default-tls-cert', optional = true }
    },
    {
        name = 'central-htpasswd-volume',
        secret = { secretName = 'central-htpasswd', optional = true }
    },
    {
        name = 'central-jwt-volume',
        secret = {
            secretName = 'central-tls',
            items = { { key = 'jwt-key.pem', path = 'jwt-key.pem' } },
        },
    },
    {
        name = 'additional-ca-volume',
        secret = {
            secretName = 'additional-ca',
            optional = true,
        },
    },
    {
        name = 'central-license-volume',
        secret = {
            secretName = 'central-license',
            optional = true,
        },
    },
    {
        name = 'central-config-volume',
        configMap = {
            name = 'central-config',
            optional = true,
        },
    },
    {
        name = 'proxy-config-volume',
        secret = {
            secretName = 'proxy-config',
            optional = true,
        },
    },
    { name = 'endpoints-config-volume', configMap = { name = 'central-endpoints' } },
    { name = 'central-db-password',     secret = { secretName = 'central-db-password' } },
    {
        name = 'central-external-db-volume',
        configMap = {
            name = 'central-external-db',
            optional = true,
        }
    },
    {
        name = 'declarative-configurations',
        configMap = {
            name = 'declarative-configurations',
            optional = true,
        },
    },
    {
        name = 'sensitive-declarative-configurations',
        secret = {
            secretName = 'sensitive-declarative-configurations',
            optional = true,
        },
    },
}

local container = {
    name = 'central',
    image = 'quay.io/stackrox-io/main:4.8.x-48-gbc8957943f',
    command = { '/stackrox/central-entrypoint.sh' },
    ports = { { containerPort = 8443, name = 'api' } },
    readinessProbe = {
        httpGet = {
            scheme = 'HTTPS',
            path = '/v1/ping',
            port = 8443,
        },
    },
    resources = {
        limits = {
            cpu = '4000m',
            memory = '8Gi',
        },
        requests = {
            cpu = '1500m',
            memory = '4Gi',
        },
    },
    securityContext = {
        capabilities = {
            drop = { 'NET_RAW' },
        },
        readOnlyRootFilesystem = true,
    },
    env = env,
    volumeMounts = volumeMounts,
}

local labeler = require('labeler')

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'apps/v1',
        kind = 'Deployment',
        metadata = {
            name = 'central',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        spec = {
            replicas = 1,
            minReadySeconds = 15,
            selector = { matchLabels = { app = 'central' } },
            strategy = { type = 'Recreate' },
            template = {
                metadata = {
                    namespace = 'stackrox',
                    labels = o.labels,
                    annotations = labeler(o.annotations, {
                        ['traffic.sidecar.istio.io/excludeInboundPorts'] = '8443',
                    }),
                },
                spec = {
                    affinity = require('central-affinity'),
                    serviceAccountName = 'central',
                    securityContext = {
                        fsGroup = 4000,
                        runAsUser = 4000,
                    },
                    containers = { container },
                    volumes = volumes,
                },
            },
        },
    }
end

return M
