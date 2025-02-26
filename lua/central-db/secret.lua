local M = {}

M.setup = function(labels, annotations)
    return {
        apiVersion = 'v1',
        kind = 'Secret',
        metadata = {
            name = 'central-db-password',
            namespace = 'stackrox',
            labels = labels,
            annotations = annotations,
        },
        type = 'Opaque',
        stringData = { password = '1234' },
    }
end

return M

