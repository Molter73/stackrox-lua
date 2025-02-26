local M = {}

M.setup = function(labels, annotations)
    return {
        apiVersion = 'networking.k8s.io/v1',
        kind = 'NetworkPolicy',
        metadata = {
            name = 'central-db',
            namespace = 'stackrox',
            labels = labels or {},
            annotations = annotations or {},
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
