local M = {}

M.setup = function(labels, annotations)
    return {
        apiVersion = 'networking.k8s.io/v1',
        kind = 'NetworkPolicy',
        metadata = {
            name = 'allow-ext-to-central',
            namespace = 'stackrox',
            labels = labels,
            annotations = annotations,
        },
        spec = {
            ingress = {
                { ports = { { port = 8443, protocol = 'TCP' } } },
            },
            podSelector = { matchLabels = { app = 'central' } },
            policyTypes = { 'Ingress' },
        },
    }
end

return M
