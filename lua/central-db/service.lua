local M = {}

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'v1',
        kind = 'Service',
        metadata = {
            name = 'central-db',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        spec = {
            ports = {
                {
                    name = 'tcp-db',
                    port = 5432,
                    protocol = 'TCP',
                    targetPort = 'postgresql',
                },
            },
            selector = { app = 'central-db' },
            type = 'ClusterIP',
        },
    }
end

return M
