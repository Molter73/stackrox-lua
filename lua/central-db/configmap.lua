local M = {}
local f = require('utils.file')

M.setup = function(labels, annotations)
    return {
        apiVersion = 'v1',
        kind = 'ConfigMap',
        metadata = {
            name = 'central-db-config',
            namespace = 'stackrox',
            labels = labels or {},
            annotations = annotations or {},
        },
        data = {
            ['postgresql.conf'] = f.readAll('config/postgresql.conf.default'),
            ['pg_hba.conf'] = f.readAll('config/pg_hba.conf.default'),
        },
    }
end

return M
