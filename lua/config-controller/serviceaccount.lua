return {
    apiVersion = 'v1',
    kind = 'ServiceAccount',
    metadata = {
        name = 'config-controller',
        namespace = 'stackrox',
    },
    imagePullSecrets = {
        { name = 'stackrox' },
        { name = 'stackrox-scanner' },
    },
}
