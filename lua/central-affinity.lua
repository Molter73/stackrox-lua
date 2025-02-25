return {
    nodeAffinity = {
        preferredDuringSchedulingIgnoredDuringExecution = { {
            -- Central-db is single-homed, so avoid preemptible nodes.
            weight = 100,
            preference = {
                matchExpressions = { {
                    key = 'cloud.google.com/gke-preemptible',
                    operator = 'NotIn',
                    values = { "true" },
                } },
            },
        }, {
            weight = 50,
            preference = {
                matchExpressions = {
                    { key = 'node-role.kubernetes.io/infra', operator = 'Exists' },
                },
            },
        }, {
            weight = 25,
            preference = {
                matchExpressions = {
                    { key = 'node-role.kubernetes.io/compute', operator = 'Exists' },
                },
            },
        }, {
            -- From v1.20 node-role.kubernetes.io/control-plane replaces node-role.kubernetes.io/master (removed in
            -- v1.25). We apply both because our goal is not to run pods on control plane nodes for any version of k8s.
            weight = 100,
            preference = {
                matchExpressions = {
                    { key = 'node-role.kubernetes.io/master', operator = 'DoesNotExist' },
                },
            },
        }, {
            weight = 100,
            preference = {
                matchExpressions = {
                    { key = 'node-role.kubernetes.io/control-plane', operator = 'DoesNotExist' },
                },
            },
        }, },
    },
}

