local M = {}

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'v1',
        kind = 'ServiceAccount',
        metadata = {
            name = 'central',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        imagePullSecrets = {
            { name = 'stackrox' },
            { name = 'stackrox-scanner' },
        },
    }
end

return M
