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

M.rbac = function(opts)
    return setup(require('config-controller.rbac'), opts)
end

M.serviceaccount = function(opts)
    return setup(require('config-controller.serviceaccount'), opts)
end

M.deployment = function(opts)
    return setup(require('config-controller.deployment'), opts)
end

return M
