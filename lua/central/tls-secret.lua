local f = require('utils.file')

return {
    apiVersion = 'v1',
    kind = 'Secret',
    metadata = {
        name = 'central-tls',
        namespace = 'stackrox',
    },
    type = 'Opaque',
    stringData = {
        ['ca.pem'] = f.readAll('./secrets/ca.pem'),
        ['ca-key.pem'] = f.readAll('./secrets/ca-key.pem'),
        ['cert.pem'] = f.readAll('./secrets/cert.pem'),
        ['key.pem'] = f.readAll('./secrets/key.pem'),
        ['jwt-key.pem'] = f.readAll('./secrets/jwt-key.pem'),
    },
}
