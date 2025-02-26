local M = {}

local manager = function(image)
    return {
        name = 'manager',
        image = image.fullRef,
        command = { '/stackrox/bin/config-controller' },
        args = { '--health-probe-bind-address=:8081' },
        env = {
            {
                name = 'POD_NAMESPACE',
                valueFrom = {
                    fieldRef = { fieldPath = 'metadata.namespace' },
                }
            },
            { name = 'ROX_DECLARATIVE_CONFIGURATION', value = 'true' },
            { name = 'ROX_DEVELOPMENT_BUILD',         value = 'true' },
            { name = 'ROX_HOTRELOAD',                 value = 'false' },
            { name = 'ROX_MANAGED_CENTRAL',           value = 'false' },
            { name = 'ROX_NETWORK_ACCESS_LOG',        value = 'false' },
        },
        livenessProbe = {
            httpGet = {
                path = '/healthz',
                port = 8081,
            },
            initialDelaySeconds = 15,
            periodSeconds = 20,
            failureThreshold = 50,
        },
        readinessProbe = {
            httpGet = {
                path = '/healthz',
                port = 8081,
            },
            initialDelaySeconds = 5,
            periodSeconds = 10,
        },
        securityContext = {
            allowPrivilegeEscalation = false,
            capabilities = { drop = { 'ALL' } },
            readOnlyRootFilesystem = true,
        },
        resources = {
            requests = {
                cpu = '10m',
                memory = '64Mi',
            },
            limits = {
                cpu = '500m',
                memory = '128Mi',
            },
        },
        volumeMounts = { {
            name = 'central-certs-volume',
            mountPath = '/run/secrets/stackrox.io/certs/',
            readOnly = true,
        } }
    }
end

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'apps/v1',
        kind = 'Deployment',
        metadata = {
            name = 'config-controller',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        spec = {
            replicas = 1,
            minReadySeconds = 15,
            selector = { matchLabels = { app = 'config-controller' } },
            strategy = { type = 'Recreate' },
            template = {
                metadata = {
                    namespace = 'stackrox',
                    labels = o.labels,
                },
                spec = {
                    serviceAccountName = 'config-controller',
                    securityContext = {
                        fsGroup = 4000,
                        runAsUser = 4000,
                    },
                    containers = {
                        manager(o.image),
                    },
                    terminationGracePeriodSeconds = 10,
                    volumes = { {
                        name = 'central-certs-volume',
                        secret = {
                            defaultMode = 420,
                            items = { { key = 'ca.pem', path = 'ca.pem' } },
                            secretName = 'central-tls',
                        },
                    } },
                }
            },
        },
    }
end

return M
