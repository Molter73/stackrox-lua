local M = {}

M.setup = function(labels, annotations)
    M.labels = labels or {}
    M.annotations = annotations or {}
    M.label = require('labeler')
    return M
end

local setup = function(mod, l, a)
    local labels = M.label(M.labels, l)
    local annotations = M.label(M.annotations, a)
    return mod.setup(labels, annotations)
end

M.serviceaccount = function(labels, annotations)
    return setup(require('central.serviceaccount'), labels, annotations)
end

M.tls_secret = function(labels, annotations)
    return setup(require('central.tls-secret'), labels, annotations)
end

M.configmap = function(labels, annotations)
    return setup(require('central.configmap'), labels, annotations)
end

M.external_db_configmap = function(labels, annotations)
    return setup(require('central.external-db-configmap'), labels, annotations)
end

M.endpoints_configmap = function(labels, annotations)
    return setup(require('central.endpoints-configmap'), labels, annotations)
end

M.networkpolicy = function(labels, annotations)
    return setup(require('central.networkpolicy'), labels, annotations)
end

M.deployment = function(labels, annotations)
    return setup(require('central.deployment'), labels, annotations)
end

M.service = function(labels, annotations)
    return setup(require('central.service'), labels, annotations)
end

return M
