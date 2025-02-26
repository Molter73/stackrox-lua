local M = {}

M.setup = function(labels, annotations)
    return {
        apiVersion = 'v1',
        kind = 'ServiceAccount',
        metadata = {
            name = 'central',
            namespace = 'stackrox',
            labels = labels,
            annotations = annotations,
        },
        imagePullSecrets = {
            { name = 'stackrox' },
            { name = 'stackrox-scanner' },
        },
    }
end

return M
