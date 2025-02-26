local M = {}

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'v1',
        kind = 'ConfigMap',
        metadata = {
            name = 'central-endpoints',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        data = { ['endpoints.yaml'] = '' },
    }
end

return M
