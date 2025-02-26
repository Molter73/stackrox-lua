Merge = function(left, right)
    local out = {}
    for key, value in pairs(left) do
        out[key] = value
    end

    local r = right or {}
    for key, value in pairs(r) do
        out[key] = value
    end

    return out
end

return Merge
