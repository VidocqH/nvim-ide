local node = require('ide.trees.node')
local icon_set = require('ide.icons').global_icon_set

local StatusNode = {}

StatusNode.new = function(status, path, staged, depth)
    local key = string.format("%s:%s", path, vim.inspect(staged))
    local self = node.new("status", status, key, depth)
    self.status = status
    self.path = path
    self.staged = staged

    -- Marshal a statusnode into a buffer line.
    --
    -- @return: @icon - @string, icon for status's kind
    --          @name - @string, status's name
    --          @details - @string, status's detail if exists.
    function self.marshal()
        local icon = ""
        -- use webdev icons if possible
        if pcall(require, "nvim-web-devicons") then
            icon = require("nvim-web-devicons").get_icon(self.path, nil, { default = true })
        end
        if self.depth == 1 then
            icon = icon_set.get_icon("GitCompare")
        end
        if vim.fn.isdirectory(self.path) ~= 0 then
            icon = icon_set.get_icon("Folder")
        end
        if self.depth == 0 then
            icon = icon_set.get_icon("GitRepo")
        end
        local name = self.path
        local detail = self.status
        return icon, name, detail
    end

    return self
end

return StatusNode
