local f = require('utils.file')

return {
    apiVersion = 'v1',
    kind = 'ConfigMap',
    metadata = {
        name = 'central-db-config',
        namespace = 'stackrox',
    },
    data = {
        ['postgresql.conf'] = f.readAll('config/postgresql.conf.default'),
        ['pg_hba.conf'] = f.readAll('config/pg_hba.conf.default'),
    },
}
