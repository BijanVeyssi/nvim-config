local M = {}

function M.telescope(builtin, opts)
    return function()
        require("telescope.builtin")[builtin](opts)
    end
end

function M.get_or_default(value, default)
    if value ~= nil then
        return value
    else
        return default
    end
end

return M
