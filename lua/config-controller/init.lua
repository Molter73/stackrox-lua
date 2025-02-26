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

M.rbac = function(labels, annotations)
    return setup(require('config-controller.rbac'), labels, annotations)
end

M.serviceaccount = function(labels, annotations)
    return setup(require('config-controller.serviceaccount'), labels, annotations)
end

M.deployment = function(labels, annotations)
    return setup(require('config-controller.deployment'), labels, annotations)
end

return M
