local M = {}

M.setup = function(labels, annotations)
    return {
        apiVersion = 'v1',
        kind = 'Secret',
        metadata = {
            name = 'central-htpasswd',
            namespace = 'stackrox',
            labels = labels,
            annotations = annotations,
        },
        type = 'Opaque',
        stringData = { htpasswd = require('utils.file').readAll('./secrets/htpasswd') },
    }
end

return M
