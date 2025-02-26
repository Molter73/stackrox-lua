local M = {}

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'v1',
        kind = 'ConfigMap',
        metadata = {
            name = 'central-external-db',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        data = {
            ['central-external-db.yaml'] = [[
    centralDB:
      external: false
      source: >
        host=central-db.stackrox.svc
        port=5432
        user=postgres
        sslmode=verify-full
        sslrootcert=/run/secrets/stackrox.io/certs/ca.pem
        statement_timeout=1.2e+06
        pool_min_conns=10
        pool_max_conns=90
        client_encoding=UTF8
            ]],
        }
    }
end

return M
