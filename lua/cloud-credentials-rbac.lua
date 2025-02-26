local M = {}

M.setup = function(labels, annotations)
    M.labels = labels
    M.annotations = annotations
    return M
end

M.role = {
    apiVersion = 'rbac.authorization.k8s.io/v1',
    kind = 'Role',
    metadata = {
        name = 'central-sts-config-reader',
        namespace = 'stackrox',
        labels = M.labels,
        annotations = M.annotations,
    },
    rules = {
        {
            apiGroups = { '' },
            resources = { 'secrets' },
            resourceNames = { 'gcp-cloud-credentials' },
            verbs = {
                'get',
                'list',
                'watch',
            },
        },
    }
}

M.roleBinding = {
    apiVersion = 'rbac.authorization.k8s.io/v1',
    kind = 'RoleBinding',
    metadata = {
        name = 'central-sts-config-reader',
        namespace = 'stackrox',
        labels = M.labels,
        annotations = M.annotations,
    },
    subjects = {
        {
            kind = 'ServiceAccount',
            name = 'central',
            namespace = 'stackrox',
        },
    },
    roleRef = {
        kind = 'Role',
        name = 'central-sts-config-reader',
        apiGroup = 'rbac.authorization.k8s.io',
    },
}


return M
