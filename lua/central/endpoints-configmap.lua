local M = {}

M.setup = function(labels, annotations)
    return {
        apiVersion = 'v1',
        kind = 'ConfigMap',
        metadata = {
            name = 'central-endpoints',
            namespace = 'stackrox',
            labels = labels,
            annotations = annotations,
        },
        data = { ['endpoints.yaml'] = '' },
    }
end

return M
