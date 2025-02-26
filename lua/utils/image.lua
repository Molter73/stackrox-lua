local M = {}

M.build = function(image)
    if image.fullRef == nil then
        local msg = 'Unable to construct image: '
        assert(image.registry, msg .. 'nil registry')
        assert(image.name, msg .. 'nil name')
        assert(image.tag, msg .. 'nil tag')
        image.fullRef = image.registry .. '/' .. image.name .. ':' .. image.tag
    else
        local _, _, registry, name, tag = string.find(image.fullRef, '(.*)/(.*):(.*)')
        image.registry = registry
        image.name = name
        image.tag = tag
    end
end

return M
