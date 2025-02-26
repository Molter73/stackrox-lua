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
        name = 'stackrox-central-diagnostics',
        namespace = 'stackrox',
        labels = M.labels,
        annotations = M.annotations,
    },
    rules = {
        {
            apiGroups = { '*' },
            resources = {
                'deployments',
                'daemonsets',
                'replicasets',
                'configmaps',
                'services',
                'pods',
                'pods/log',
                'events',
                'namespaces',
            },
            verbs = {
                'get',
                'list',
            },
        },
    }
}

M.roleBinding = {
    apiVersion = 'rbac.authorization.k8s.io/v1',
    kind = 'RoleBinding',
    metadata = {
        name = 'stackrox-central-diagnostics',
        namespace = 'stackrox',
        labels = M.labels,
        annotations = M.annotations,
    },
    roleRef = {
        apiGroup = 'rbac.authorization.k8s.io',
        kind = 'Role',
        name = 'stackrox-central-diagnostics',
    },
    subjects = {
        {
            kind = 'ServiceAccount',
            name = 'central',
            namespace = 'stackrox',
        },
    }
}


return M
