return {
    apiVersion = 'v1',
    kind = 'Service',
    metadata = {
        name = 'central',
        namespace = 'stackrox',
    },
    spec = {
        ports = { { name = 'https', port = 443, targetPort = 'api' } },
        selector = { app = 'central' },
        type = 'ClusterIP',
    },
}
