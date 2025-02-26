local M = {}

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'networking.k8s.io/v1',
        kind = 'NetworkPolicy',
        metadata = {
            name = 'central-db',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        spec = {
            policyTypes = {
                'Ingress',
                'Egress',
            },
            ingress = {
                {
                    from = {
                        { podSelector = { matchLabels = { app = 'central' } } },
                    },
                    ports = { { port = 5432, protocol = 'TCP' } },
                },
            },
            podSelector = { matchLabels = { app = 'central-db' } },
        },
    }
end

return M
