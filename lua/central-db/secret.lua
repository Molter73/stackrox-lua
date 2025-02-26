local M = {}

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'v1',
        kind = 'Secret',
        metadata = {
            name = 'central-db-password',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        type = 'Opaque',
        stringData = { password = '1234' },
    }
end

return M

