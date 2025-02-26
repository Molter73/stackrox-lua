local M = {}

M.setup = function(labels, annotations)
    M.labels = labels
    M.annotations = annotations
    return M
end

local rule = {
    apiGroups = { 'config.stackrox.io' },
    resources = {
        'securitypolicies',
        'securitypolicies/status',
    },
    verbs = {
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
    },
}

M.role = {
    apiVersion = 'rbac.authorization.k8s.io/v1',
    kind = 'Role',
    metadata = {
        name = 'config-controller-manager-role',
        namespace = 'stackrox',
        labels = M.labels,
        annotations = M.annotations,
    },
    rules = { rule },
}

M.roleBinding = {
    apiVersion = 'rbac.authorization.k8s.io/v1',
    kind = 'RoleBinding',
    metadata = {
        name = 'config-controller-manager-rolebinding',
        namespace = 'stackrox',
        labels = M.labels,
        annotations = M.annotations,
    },
    roleRef = {
        apiGroup = 'rbac.authorization.k8s.io',
        kind = 'Role',
        name = 'config-controller-manager-role',
    },
    subjects = {
        {
            kind = 'ServiceAccount',
            name = 'config-controller',
            namespace = 'stackrox',
        },
    },
}

return M
