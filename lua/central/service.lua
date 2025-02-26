local M = {}

M.setup = function(labels, annotations)
    return {
        apiVersion = 'v1',
        kind = 'Service',
        metadata = {
            name = 'central',
            namespace = 'stackrox',
            labels = labels,
            annotations = annotations,
        },
        spec = {
            ports = { { name = 'https', port = 443, targetPort = 'api' } },
            selector = { app = 'central' },
            type = 'ClusterIP',
        },
    }
end

return M
