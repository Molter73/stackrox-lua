local cloud_credentials_rbac = require('cloud-credentials-rbac')
local diagnostics_rbac = require('diagnostics-rbac')
local central_db_deploy = require('central-db.deployment')
local config_controller_rbac = require('config-controller.rbac')

local central = {
    require('central-db.serviceaccount'),
    require('central.serviceaccount'),
    cloud_credentials_rbac.role,
    cloud_credentials_rbac.roleBinding,
    diagnostics_rbac.role,
    diagnostics_rbac.roleBinding,
    require('htpasswd-secret'),
    require('central-db.tls-secret'),
    require('central.tls-secret'),
    require('central.configmap'),
    require('central-db.configmap'),
    require('central.external-db-configmap'),
    require('central.endpoints-configmap'),
    require('central-db.networkpolicy'),
    require('central.networkpolicy'),
    central_db_deploy.deployment,
    central_db_deploy.service,
    central_db_deploy.secret,
    require('central.deployment'),
    require('central.service'),
    require('config-controller.serviceaccount'),
    config_controller_rbac.role,
    config_controller_rbac.roleBinding,
    require('config-controller.deployment'),
}

return central
