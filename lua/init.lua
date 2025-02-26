local labels = {
    ['app.kubernetes.io/component'] = 'central',
    ['app.kubernetes.io/instance'] = 'stackrox-central-services',
    ['app.kubernetes.io/managed-by'] = 'Helm',
    ['app.kubernetes.io/name'] = 'stackrox',
    ['app.kubernetes.io/part-of'] = 'stackrox-central-services',
    ['app.kubernetes.io/version'] = '4.8.x-48-gbc8957943f',
    ['helm.sh/chart'] = 'stackrox-central-services-400.8.0-48-gbc8957943f',
}

local annotations = {
    email = 'support@stackrox.com',
    ['meta.helm.sh/release-name'] = 'stackrox-central-services',
    ['meta.helm.sh/release-namespace'] = 'stackrox',
    owner = 'stackrox',
}

local central_db = require('central-db.init').setup(labels, annotations)
local central = require('central.init').setup(labels, annotations)
local cloud_credentials_rbac = require('cloud-credentials-rbac').setup(labels, annotations)
local diagnostics_rbac = require('diagnostics-rbac').setup(labels, annotations)
local config_controller = require('config-controller.init').setup(labels, annotations)
local config_controller_rbac = config_controller.rbac(labels, annotations)

return {
    central_db.serviceaccount(),
    central.serviceaccount(),
    cloud_credentials_rbac.role,
    cloud_credentials_rbac.roleBinding,
    diagnostics_rbac.role,
    diagnostics_rbac.roleBinding,
    require('htpasswd-secret').setup(labels, annotations),
    central_db.tls_secret({
        ['rhacs.redhat.com/tls'] = 'true',
    }, {
        ['helm.sh/hook'] = 'pre-install,pre-upgrade',
        ['helm.sh/resource-policy'] = 'keep',
    }),
    central.tls_secret({
        ['rhacs.redhat.com/tls'] = 'true',
    }, {
        ['helm.sh/hook'] = 'pre-install,pre-upgrade',
        ['helm.sh/resource-policy'] = 'keep',
    }),
    central.configmap(),
    central_db.configmap(),
    central.external_db_configmap(),
    central.endpoints_configmap(),
    central_db.networkpolicy(),
    central.networkpolicy(),
    central_db.deployment({ app = 'central-db' }),
    central_db.service(),
    central_db.secret(),
    central.deployment({ app = 'central' }),
    central.service(),
    config_controller.serviceaccount(),
    config_controller_rbac.role,
    config_controller_rbac.roleBinding,
    config_controller.deployment({ app = 'config-controller' })
}
