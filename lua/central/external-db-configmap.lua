local M = {}

M.setup = function(labels, annotations)
    return {
        apiVersion = 'v1',
        kind = 'ConfigMap',
        metadata = {
            name = 'central-external-db',
            namespace = 'stackrox',
            labels = labels,
            annotations = annotations,
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
