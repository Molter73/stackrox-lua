return {
    apiVersion = 'v1',
    kind = 'ServiceAccount',
    metadata = {
        name = 'central',
        namespace = 'stackrox',
    },
    imagePullSecrets = {
        { name = 'stackrox' },
        { name = 'stackrox-scanner' },
    },
}
