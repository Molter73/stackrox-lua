local M = {}

M.setup = function(opts)
    local o = opts or {}
    return {
        apiVersion = 'v1',
        kind = 'ConfigMap',
        metadata = {
            name = 'central-config',
            namespace = 'stackrox',
            labels = o.labels,
            annotations = o.annotations,
        },
        data = {
            ['central-config.yaml'] = [[
    maintenance:
      safeMode: false # When set to true, Central will sleep forever on the next restart
      compaction:
        enabled: true
        bucketFillFraction: .5 # This controls how densely to compact the buckets. Usually not advised to modify
        freeFractionThreshold: 0.75 # This is the threshold for free bytes / total bytes after which compaction will occur
      forceRollbackVersion: none # This is the config and target rollback version after upgrade complete.
        ]]
        },
    }
end

return M
