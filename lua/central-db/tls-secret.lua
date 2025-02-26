local M = {}
local f = require('utils.file')

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'v1',
        kind = 'Secret',
        metadata = {
            name = 'central-db-tls',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
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
