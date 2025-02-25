return {
    apiVersion = 'v1',
    kind = 'Secret',
    metadata = {
        name = 'central-htpasswd',
        namespace = 'stackrox',
    },
    type = 'Opaque',
    stringData = { htpasswd = require('utils.file').readAll('./secrets/htpasswd') },
}
