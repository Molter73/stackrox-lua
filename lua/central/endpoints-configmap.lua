return {
    apiVersion = 'v1',
    kind = 'ConfigMap',
    metadata = {
        name = 'central-endpoints',
        namespace = 'stackrox',
    },
    data = { ['endpoints.yaml'] = '' },
}
