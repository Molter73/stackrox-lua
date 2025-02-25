local M = {}

M.readAll = function(path)
    local f = assert(io.open(path, 'r'))
    local content = f:read('all')
    f:close()
    return content
end

return M
