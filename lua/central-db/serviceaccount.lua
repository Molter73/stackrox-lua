local M = {}

M.setup = function(labels, annotations)
    return {
        apiVersion = 'v1',
        kind = 'ServiceAccount',
        metadata = {
            name = 'central-db',
            namespace = 'stackrox',
            labels = labels or {},
            annotations = annotations or {},
        },
        imagePullSecrets = {
            { name = 'stackrox' },
            { name = 'stackrox-scanner' },
        },
    }
end

return M
