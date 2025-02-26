local M = {}
local f = require('utils.file')

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'v1',
        kind = 'ConfigMap',
        metadata = {
            name = 'central-db-config',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        data = {
            ['postgresql.conf'] = f.readAll('config/postgresql.conf.default'),
            ['pg_hba.conf'] = f.readAll('config/pg_hba.conf.default'),
        },
    }
end

return M
