return {
    apiVersion = 'v1',
    kind = 'ServiceAccount',
    metadata = {
        name = 'central-db',
        namespace = 'stackrox',
    },
    imagePullSecrets = {
        { name = 'stackrox' },
        { name = 'stackrox-scanner' },
    },
}
