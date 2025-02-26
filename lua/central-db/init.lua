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
        image = o.image,
    })
end

M.serviceaccount = function(opts)
    return setup(require('central-db.serviceaccount'), opts)
end

M.tls_secret = function(opts)
    return setup(require('central-db.tls-secret'), opts)
end

M.configmap = function(opts)
    return setup(require('central-db.configmap'), opts)
end

M.networkpolicy = function(opts)
    return setup(require('central-db.networkpolicy'), opts)
end

M.deployment = function(opts)
    return setup(require('central-db.deployment'), opts)
end

M.service = function(opts)
    return setup(require('central-db.service'), opts)
end

M.secret = function(opts)
    return setup(require('central-db.secret'), opts)
end

return M
