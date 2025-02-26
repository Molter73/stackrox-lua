local M = {}
local f = require('utils.file')

M.setup = function(labels, annotations)
    return {
        apiVersion = 'v1',
        kind = 'Secret',
        metadata = {
            name = 'central-db-tls',
            namespace = 'stackrox',
            labels = labels or {},
            annotations = annotations or {},
        },
        type = 'Opaque',
        stringData = {
            ['ca.pem'] = f.readAll('./secrets/ca.pem'),
            ['cert.pem'] = f.readAll('./secrets/cert.pem'),
            ['key.pem'] = f.readAll('./secrets/key.pem'),
        }
    }
end

return M
