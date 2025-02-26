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
    return setup(require('central-db.serviceaccount'), labels, annotations)
end

M.tls_secret = function(labels, annotations)
    return setup(require('central-db.tls-secret'), labels, annotations)
end

M.configmap = function(labels, annotations)
    return setup(require('central-db.configmap'), labels, annotations)
end

M.networkpolicy = function(labels, annotations)
    return setup(require('central-db.networkpolicy'), labels, annotations)
end

M.deployment = function(labels, annotations)
    return setup(require('central-db.deployment'), labels, annotations)
end

M.service = function(labels, annotations)
    return setup(require('central-db.service'), labels, annotations)
end

M.secret = function(labels, annotations)
    return setup(require('central-db.secret'), labels, annotations)
end

return M
