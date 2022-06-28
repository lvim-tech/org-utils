local config = require("lvim-org-utils.config")
local utils = require("lvim-org-utils.utils")
local links = require("lvim-org-utils.links")
local style = require("lvim-org-utils.style")
local codeblock = require("lvim-org-utils.codeblock")

local M = {}

M.setup = function(user_config)
    if user_config ~= nil then
        utils.merge(config, user_config)
    end
    local group = vim.api.nvim_create_augroup("LvimOrgUtils", {
        clear = true,
    })
    vim.api.nvim_create_autocmd({
        "BufEnter",
        "WinEnter",
    }, {
        pattern = "*.org",
        callback = function()
            if vim.bo.modified == false then
                vim.cmd("edit!")
            end
        end,
        group = group,
    })
    vim.api.nvim_create_autocmd({
        "BufEnter",
        "WinEnter",
        "FileChangedShellPost",
        "Syntax",
        "CursorMoved",
        "TextChanged",
        "InsertLeave",
        "WinScrolled",
    }, {
        pattern = "*.org",
        callback = function()
            vim.schedule(function()
                vim.schedule(function()
                    vim.cmd([[setlocal foldexpr=OrgmodeFoldExpr()]])
                end)
            end)
            if config.links.active then
                links.navigation()
            end
            if config.codeblock.active then
                codeblock.code_block()
            end
        end,
        group = group,
    })
    if config.links.active then
        links.init()
    end
    if config.style.active then
        style.init()
    end
end

return M
