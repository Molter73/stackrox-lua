local M = {}

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'v1',
        kind = 'Secret',
        metadata = {
            name = 'central-htpasswd',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        type = 'Opaque',
        stringData = { htpasswd = require('utils.file').readAll('./secrets/htpasswd') },
    }
end

return M
