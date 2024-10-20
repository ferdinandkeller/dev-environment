-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo(
            {
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out,                            "WarningMsg" },
                { "\nPress any key to exit..." }
            }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', ':Lazy<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<D-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>c', '"+y', { noremap = true, silent = true })

-- Setup lazy.nvim
require("lazy").setup({
    spec = { -- add your plugins here
        -- { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false },
        -- { "slugbyte/lackluster.nvim", name = "lackluster", priority = 1000, lazy = false },
        {
            'olivercederborg/poimandres.nvim',
            lazy = false,
            priority = 1000,
            config = function()
                require('poimandres').setup {
                    -- leave this setup function empty for default config
                    -- or refer to the configuration section
                    -- for configuration options
                    --
                    disable_background = true
                }
            end,

            -- optionally set the colorscheme within lazy config
            init = function()
                vim.cmd("colorscheme poimandres")
            end
        },
        { 'nvim-lua/plenary.nvim',          lazy = false },
        { "nvim-treesitter/nvim-treesitter" },
        {
            'nvim-telescope/telescope.nvim',
            branch = '0.1.x',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = false },
        {
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup {
                    -- Enabling Tree-sitter support
                    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
                }
            end
        }
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = {
        colorscheme = { "habamax" }
    },
    -- automatically check for plugin updates
    checker = {
        enabled = true
    }
})

-- vim.cmd([[
--     colorscheme poimandres
--     highlight Normal guibg=none
--     highlight NonText guibg=none
-- ]])

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.api.nvim_set_keymap('n', '<leader>g', 'gcc<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>g', 'gc<CR>', { noremap = true, silent = true })
