local M = {}

M.setup = function(opts)
    M.opts = opts or {}
    M.label = require('labeler')
    return M
end

local setup = function(mod, opts)
    local o = opts or {}
    local labels = M.label(M.opts.labels, o.labels)
    local annotations = M.label(M.opts.annotations, o.annotations)
    return mod.setup({
        labels = labels,
        annotations = annotations,
    })
end

M.serviceaccount = function(opts)
    return setup(require('central.serviceaccount'), opts)
end

M.tls_secret = function(opts)
    return setup(require('central.tls-secret'), opts)
end

M.configmap = function(opts)
    return setup(require('central.configmap'), opts)
end

M.external_db_configmap = function(opts)
    return setup(require('central.external-db-configmap'), opts)
end

M.endpoints_configmap = function(opts)
    return setup(require('central.endpoints-configmap'), opts)
end

M.networkpolicy = function(opts)
    return setup(require('central.networkpolicy'), opts)
end

M.deployment = function(opts)
    return setup(require('central.deployment'), opts)
end

M.service = function(opts)
    return setup(require('central.service'), opts)
end

return M
