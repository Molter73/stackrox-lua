-- configurable items
local main_image = {
    registry = main_registry or 'quay.io/stackrox-io',
    name = main_name or 'main',
    tag = main_tag or '4.8.x-48-gbc8957943f',
    fullRef = main_ref or nil,
}

local db_image = {
    registry = db_registry or 'quay.io/stackrox-io',
    name = db_name or 'central-db',
    tag = db_tag or '4.8.x-48-gbc8957943f',
    fullRef = db_ref or nil,
}

local image = require('utils.image')
image.build(main_image)
image.build(db_image)

local labels = {
    ['app.kubernetes.io/component'] = 'central',
    ['app.kubernetes.io/instance'] = 'stackrox-central-services',
    ['app.kubernetes.io/managed-by'] = 'Helm',
    ['app.kubernetes.io/name'] = 'stackrox',
    ['app.kubernetes.io/part-of'] = 'stackrox-central-services',
    ['app.kubernetes.io/version'] = main_image.tag,
    ['helm.sh/chart'] = 'stackrox-central-services-400.8.0-48-gbc8957943f',
}

local annotations = {
    email = 'support@stackrox.com',
    ['meta.helm.sh/release-name'] = 'stackrox-central-services',
    ['meta.helm.sh/release-namespace'] = 'stackrox',
    owner = 'stackrox',
}

local opts = {
    labels = labels,
    annotations = annotations,
}
local tls_opts = {
    labels = {
        ['rhacs.redhat.com/tls'] = 'true',
    },
    annotations = {
        ['helm.sh/hook'] = 'pre-install,pre-upgrade',
        ['helm.sh/resource-policy'] = 'keep',
    }
}

local central_db = require('central-db.init').setup(opts)
local central = require('central.init').setup(opts)
local cloud_credentials_rbac = require('cloud-credentials-rbac').setup(opts)
local diagnostics_rbac = require('diagnostics-rbac').setup(opts)
local config_controller = require('config-controller.init').setup(opts)
local config_controller_rbac = config_controller.rbac(opts)

return {
    central_db.serviceaccount(),
    central.serviceaccount(),
    cloud_credentials_rbac.role,
    cloud_credentials_rbac.roleBinding,
    diagnostics_rbac.role,
    diagnostics_rbac.roleBinding,
    require('htpasswd-secret').setup(opts),
    central_db.tls_secret(tls_opts),
    central.tls_secret(tls_opts),
    central.configmap(),
    central_db.configmap(),
    central.external_db_configmap(),
    central.endpoints_configmap(),
    central_db.networkpolicy(),
    central.networkpolicy(),
    central_db.deployment({
        image = db_image,
        labels = { app = 'central-db' },
    }),
    central_db.service(),
    central_db.secret(),
    central.deployment({
        image = main_image,
        labels = { app = 'central' },
    }),
    central.service(),
    config_controller.serviceaccount(),
    config_controller_rbac.role,
    config_controller_rbac.roleBinding,
    config_controller.deployment({
        image = main_image,
        labels = { app = 'config-controller' }
    })
}
