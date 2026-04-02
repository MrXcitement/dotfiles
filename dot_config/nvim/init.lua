--[[
  vim: set fdm=marker:

  init.lua -- Neovim Configuration File.
  Mike Barker <mike@thebarkers.com>
  Created: April 1st, 2026
  Updated:
--]]

local opt = vim.opt

-- Plugin Manager -- lazy.nvim {{{

-- Bootstrap lazy.nvim (Automatically install if missing) {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- }}}

-- Configuration & Plugin List
require("lazy").setup({
    -- Editing plugins
    -- "farmergreg/vim-lastplace",
    "tpope/vim-commentary",
    "tpope/vim-surround",
    "tpope/vim-unimpaired",

    -- Interface plugins
    { "clearaspect/onehalf", lazy = false, priority = 1000, },
    { "f-person/auto-dark-mode.nvim",
        opts = {
            update_interval = 5000,
            set_dark_mode = function()
                vim.cmd("colorscheme onehalfdark")
                vim.api.nvim_set_option_value("background", "dark", {})
            end,
            set_light_mode = function()
                vim.cmd("colorscheme onehalflight")
                vim.api.nvim_set_option_value("background", "light", {})
            end,
        },
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            require("lualine").setup()
        end,
    },

    -- Developer plugins
    "editorconfig/editorconfig-vim",
    -- "ervandew/supertab",
    { "airblade/vim-gitgutter", enabled = vim.fn.executable("git") == 1 },
    { "tpope/vim-fugitive",     enabled = vim.fn.executable("git") == 1 },
    -- "mattn/webapi-vim",
    -- "mattn/gist-vim",
    -- "nelstrom/vim-markdown-folding",

    -- Linting & Completion (ALE)
    -- {
    --     "dense-analysis/ale",
    --     init = function()
    --         vim.g.ale_completion_enabled = 1
    --         vim.g.ale_linters = { python = { "pylsp" } }
    --     end
    -- },

    -- Snippets
    -- {
    --     "SirVer/ultisnips",
    --     enabled = vim.fn.has("python3") == 1,
    --     dependencies = { "honza/vim-snippets" },
    --     init = function()
    --         vim.g.UltiSnipsListSnippets = "<A-tab>"
    --     end
    -- },

    -- Language Specific (Conditionals)
    -- { "pearofducks/ansible-vim", enabled = vim.fn.executable("ansible") == 1 },
    -- { "PProvost/vim-ps1",        enabled = (vim.fn.executable("pwsh") == 1 or vim.fn.executable("powershell") == 1) },
    -- {
    --     "nvie/vim-flake8",
    --     enabled = (vim.fn.executable("python") == 1 or vim.fn.executable("python3") == 1) and vim.fn.executable("flake8") == 1
    -- },
    -- { "tmhedberg/simpylfold",    enabled = (vim.fn.executable("python") == 1 or vim.fn.executable("python3") == 1) },
    -- { "rust-lang/rust.vim",      enabled = vim.fn.executable("rustc") == 1 },
    -- { "racer-rust/vim-racer",    enabled = vim.fn.executable("rustc") == 1 },
    -- { "vim-ruby/vim-ruby",       enabled = vim.fn.executable("ruby") == 1 },
    -- { "keith/swift.vim",         enabled = vim.fn.executable("swift") == 1 },
    -- { "hashivim/vim-vagrant",    enabled = vim.fn.executable("vagrant") == 1 },

},
{
    -- Automaticly check for plugin updates
    checker = { enabled = true },
    -- Disable luarocks support
    rocks = { enabled = false },
    -- Lazy UI settings
    ui = { border = "rounded" },
})
-- }}}

-- Editor Settings {{{
-- =============================================================================

-- Neovim defaults to nocompatible, and filetype/syntax are handled automatically.
-- But we can set them explicitly if you prefer:
vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')

opt.backspace = { "indent", "eol", "start" }
opt.colorcolumn = "80"
opt.encoding = "utf-8"
opt.history = 50
opt.listchars = { tab = "]-", trail = "_", extends = ">", precedes = "<", nbsp = "~", eol = "$" }
opt.foldenable = false
opt.wrap = false
opt.ruler = true
opt.showcmd = true
opt.showmatch = true

-- Conditional cursorline (equivalent to your win32 check)
if vim.fn.eval('&ttytype') ~= "win32" then
    opt.cursorline = true
end
-- }}}

-- Spelling {{{
-- =============================================================================
opt.spelllang = "en"
-- opt.spellfile = "/Users/mike/.vim/spell/en.utf-8.add"
-- }}}

-- Completion {{{
-- =============================================================================
opt.omnifunc = "syntaxcomplete#Complete"
opt.completeopt = { "menuone", "longest", "preview" }
-- }}}

-- Line Numbers {{{
-- =============================================================================
opt.relativenumber = true
opt.number = true
-- }}}

-- Searching {{{
-- =============================================================================
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
-- }}}

-- Indentation {{{
-- =============================================================================
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- }}}

-- Autocommands {{{
-- =============================================================================
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- vimrcEx Group
local vimrcEx = augroup("vimrcEx", { clear = true })
autocmd("FileType", {
    group = vimrcEx,
    pattern = "text",
    callback = function()
        vim.opt_local.textwidth = 80
    end,
})

-- Omnicompletion Popup Colors
-- local customOmnicompletionPopup = augroup("customOmnicompletionPopup", { clear = true })
-- autocmd("ColorScheme", {
--     group = customOmnicompletionPopup,
--     pattern = "*",
--     callback = function()
--         vim.api.nvim_set_hl(0, "Pmenu", { bg = "Grey", fg = "Black", ctermbg = "Grey", ctermfg = "Black" })
--         vim.api.nvim_set_hl(0, "PmenuSel", { bg = "Black", fg = "Grey", ctermbg = "DarkGrey", ctermfg = "Grey" })
--     end,
-- })

-- }}}

-- UI / GUI Settings {{{
-- =============================================================================
if vim.fn.has("gui_running") == 1 then
    if vim.fn.has("gui_gtk") == 1 then
        opt.guifont = "FiraCode Nerd Font Light 10"
        -- Ligatures logic
        if opt.guifont:get()[1]:match("Nerd") then
            vim.cmd([[set guiligatures=!\"#$%&()*+-./:<=>?@[]^_{\|~]])
        end
    elseif vim.fn.has("gui_win32") == 1 then
        opt.guifont = "FiraCode_Nerd_Font_Mono_Light:h12,Consolas:h12"
        if opt.guifont:get()[1]:match("Nerd") then
            opt.renderoptions = "type:directx"
        end
    elseif vim.fn.has("gui_mac") == 1 or vim.fn.has("gui_macvim") == 1 then
        opt.guifont = "0xProtoNFM-Regular:h12,Monaco:h12"
        if opt.guifont:get()[1]:match("NFM") then
            vim.cmd('set macligatures')
        end
    end
    opt.guioptions:remove("T")
else
    -- Cursor shapes for terminals
    -- Note: Modern Neovim usually handles this via `opt.guicursor`
    vim.api.nvim_exec([[
        let &t_SI = "\<Esc>[5 q"
        let &t_SR = "\<Esc>[3 q"
        let &t_EI = "\<Esc>[1 q"
    ]], false)
    
    if vim.fn.has("vcon") == 1 then
        opt.termguicolors = true
    end
    opt.mouse = "a"
end

-- }}}

-- Key Mappings {{{
-- =============================================================================
vim.g.mapleader = " "
local keymap = vim.keymap.set

-- Edit/Reload Config
keymap('n', '<leader>v', ':e $MYVIMRC<CR>', { silent = true })
keymap('n', '<leader>V', ':source $MYVIMRC<CR>:filetype detect<CR>:lua print("Reloaded " .. vim.env.MYVIMRC)<CR>', { silent = true })

-- Window Movement
keymap('n', '<C-J>', '<C-W><C-J>')
keymap('n', '<C-K>', '<C-W><C-K>')
keymap('n', '<C-H>', '<C-W><C-H>')
keymap('n', '<C-L>', '<C-W><C-L>')

-- Disable Arrow Keys
local arrows = { '<Up>', '<Down>', '<Left>', '<Right>' }
for _, key in ipairs(arrows) do
    keymap('', key, '<nop>')
end

-- }}}

-- Custom Functions (OpenURI / OpenFile) {{{
-- =============================================================================

local function open_file(path)
    local cmd = ""
    if vim.fn.has("win32") == 1 then
        cmd = string.format("silent !start \"%s\"", path)
    elseif vim.fn.has("unix") == 1 then
        local os_name = vim.fn.system('uname'):gsub("\n", "")
        if os_name == "Darwin" or os_name == "Mac" then
            cmd = string.format("silent !open \"%s\"", path)
        else
            cmd = string.format("silent !xdg-open \"%s\"", path)
        end
    end
    vim.cmd(cmd)
    vim.cmd("redraw!")
    print(cmd)
end

local function open_uri()
    local line = vim.fn.getline(".")
    local uri = vim.fn.matchstr(line, [[[a-z]*:\/\/[^ >,;:"]*]])
    if uri ~= "" then
        open_file(uri)
    else
        vim.api.nvim_echo({{"No URI found in current line.", "WarningMsg"}}, true, {})
    end
end

-- Mappings for functions
keymap('n', '<leader>w', open_uri)
keymap('n', '<leader>W', function()
    vim.cmd("update")
    open_file(vim.fn.expand('%:p'))
end)
-- }}}
