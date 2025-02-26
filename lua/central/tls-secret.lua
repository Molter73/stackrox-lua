local M = {}
local f = require('utils.file')

M.setup = function(labels, annotations)
    return {
        apiVersion = 'v1',
        kind = 'Secret',
        metadata = {
            name = 'central-tls',
            namespace = 'stackrox',
            labels = labels,
            annotations = annotations,
        },
        type = 'Opaque',
        stringData = {
            ['ca.pem'] = f.readAll('./secrets/ca.pem'),
            ['ca-key.pem'] = f.readAll('./secrets/ca-key.pem'),
            ['cert.pem'] = f.readAll('./secrets/cert.pem'),
            ['key.pem'] = f.readAll('./secrets/key.pem'),
            ['jwt-key.pem'] = f.readAll('./secrets/jwt-key.pem'),
        },
    }
end

return M
