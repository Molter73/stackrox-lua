local M = {}

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'v1',
        kind = 'Service',
        metadata = {
            name = 'central',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        spec = {
            ports = { { name = 'https', port = 443, targetPort = 'api' } },
            selector = { app = 'central' },
            type = 'ClusterIP',
        },
    }
end

return M
