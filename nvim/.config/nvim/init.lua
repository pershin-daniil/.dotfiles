-- NVIM v0.13.0-dev-29+g1bcf2d7f90
-- Build type: RelWithDebInfo
-- LuaJIT 2.1.1774896198

local o = vim.o
local g = vim.g
local api = vim.api

o.nu = true
o.rnu = true
o.nuw = 5

local augroup = api.nvim_create_augroup('user_config', { clear = true })

api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = { 'netrw', 'help', },
    callback = function()
        vim.opt_local.nu = true
        vim.opt_local.rnu = true
    end,
})

api.nvim_create_autocmd('BufWinEnter', {
    group = augroup,
    pattern = { '*.txt' },
    callback = function()
        vim.opt_local.nu = true
        vim.opt_local.rnu = true
    end,
})

api.nvim_create_autocmd('TextYankPost', {
    group = augroup,
    callback = function()
        vim.hl.on_yank({ higroup = 'IncSearch', timeout = 100 })
    end,
})

o.cul = true
o.wrap = false

-- read :help 30.5
vim.cmd('filetype plugin indent on')
o.sw = 4
o.sts = 2
o.et = true
o.sta = true

o.so = 999

o.grepprg = 'rg --vimgrep --smart-case --hidden'
o.grepformat = '%f:%l:%c:%m'

o.langmap =
  'ФA,ИB,СC,ВD,УE,АF,ПG,РH,ШI,ОJ,ЛK,ДL,ЬM,ТN,ЩO,ЗP,ЙQ,КR,ЫS,ЕT,ГU,МV,ЦW,ЧX,НY,ЯZ,' ..
  'фa,иb,сc,вd,уe,аf,пg,рh,шi,оj,лk,дl,ьm,тn,щo,зp,йq,кr,ыs,еt,гu,мv,цw,чx,нy,яz'

o.clipboard = 'unnamedplus'

-- :checkhealth
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
--

g.mapleader = ' '

g.netrw_banner = 0
g.netrw_hide = 0
g.netrw_liststyle = 3
g.netrw_browse_split = 0
g.netrw_altv = 1
g.netrw_winsize = 25

-- keymaps
local k = vim.keymap
k.set('n', '<Tab>', ':wincmd w<CR>')
k.set('n', '<S-Tab>', ':wincmd r<CR>')
-- Diagnostic keymaps
k.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics list' })
k.set('n', '<leader>df', vim.diagnostic.open_float, { desc = 'Diagnostic float' })

-- which-key
vim.pack.add({
    { src = 'https://github.com/folke/which-key.nvim' },
})

local ok, wk = pcall(require, 'which-key')
if ok then
    wk.setup({
        -- Manual mode: do not show automatically after pressing prefixes.
        triggers = {},
    })
    wk.add({
        { '<leader>?', group = 'show keymaps' },
        { '<leader>d', group = 'diagnostics' },
        { '<leader>f', group = 'files' },
        { '<leader>g', group = 'grep' },
        { '<leader>s', group = 'search' },
    })
    k.set('n', '<leader>?', function()
        wk.show({ keys = '<leader>', mode = 'n' })
    end, { desc = 'Show keymaps' })
else
    vim.notify(
        'which-key not loaded: ' .. tostring(wk),
        vim.log.levels.WARN,
        { title = 'nvim config' }
    )
end

-- theme
vim.pack.add({
    { src = 'https://github.com/folke/tokyonight.nvim' },
})

require('tokyonight').setup {
    styles = {
        comments = { italic = false },
    },
}
vim.cmd.colo('tokyonight-night')

-- fzf
vim.pack.add({
    { src = 'https://github.com/ibhagwan/fzf-lua' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
})

local ok, devicons = pcall(require, 'nvim-web-devicons')
if not ok then
    vim.notify(
        'nvim-web-devicons not loaded: ' .. tostring(devicons),
        vim.log.levels.WARN,
        { title = 'nvim config' }
    )
end

local ok, fzf = pcall(require, 'fzf-lua')
if ok then
    fzf.setup {
        winopts = {
            border = 'none',
            fullscreen = true,
            preview = {
                border = 'none',
                layout = 'vertical',
            },
        },
    }

    k.set('n', '<leader>fd', fzf.files, { desc = 'Find files' })
    k.set('n', '<leader>gh', fzf.lgrep_curbuf, { desc = 'Grep current buffer' })
    k.set('n', '<leader>gp', fzf.grep_project, { desc = 'Grep project' })
    k.set('n', '<leader>sn', function() fzf.grep_project({ cwd = vim.fn.stdpath 'config' }) end, { desc = 'Search Neovim config' })
    k.set('i', '<C-F><C-F>',
    function()
        fzf.complete_file({
            cmd = 'rg --files',
            winopts = { preview = { hidden = true } }
        })
    end, { silent = true, desc = 'Complete file path' })

    api.nvim_create_autocmd('VimEnter', {
        group = augroup,
        callback = function()
            if vim.fn.argc() == 0 and #vim.api.nvim_list_uis() > 0 then
                fzf.files()
            end
        end,
    })
else
    vim.notify(
        'fzf-lua not loaded: ' .. tostring(fzf),
        vim.log.levels.WARN,
        { title = 'nvim config' }
    )
end

-- wakatime
vim.pack.add({
    { src = 'https://github.com/wakatime/vim-wakatime' },
})

-- treesitter
vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
})

local ok, treesitter = pcall(require, 'nvim-treesitter')
if ok then
    treesitter.setup()
    treesitter.install({ 'c', 'cpp', 'go', 'lua' })

    api.nvim_create_autocmd('FileType', {
        group = augroup,
        pattern = { 'c', 'cpp', 'go', 'lua' },
        callback = function()
            vim.treesitter.start()
        end,
    })
else
    vim.notify(
        'nvim-treesitter not loaded: ' .. tostring(treesitter),
        vim.log.levels.WARN,
        { title = 'nvim config' }
    )
end

-- gitsigns
vim.pack.add({
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
})

local ok, gitsigns = pcall(require, 'gitsigns')
if ok then
    gitsigns.setup()
else
    vim.notify(
        'gitsigns not loaded: ' .. tostring(gitsigns),
        vim.log.levels.WARN,
        { title = 'nvim config' }
    )
end

-- mini.nvim
vim.pack.add({
    { src = 'https://github.com/echasnovski/mini.nvim' },
})

local mini_modules = {
    'mini.ai',
    'mini.pairs',
    'mini.surround',
}

for _, module in ipairs(mini_modules) do
    local mini_ok, mini = pcall(require, module)
    if mini_ok then
        mini.setup()
    else
        vim.notify(
            module .. ' not loaded: ' .. tostring(mini),
            vim.log.levels.WARN,
            { title = 'nvim config' }
        )
    end
end

-- LSP
-- 
-- These GLOBAL keymaps are created unconditionally when Nvim starts:
-- - 'gra' (Normal and Visual mode) is mapped to |vim.lsp.buf.code_action()|
-- - 'gri' is mapped to |vim.lsp.buf.implementation()|
-- - 'grn' is mapped to |vim.lsp.buf.rename()|
-- - 'grr' is mapped to |vim.lsp.buf.references()|
-- - 'grt' is mapped to |vim.lsp.buf.type_definition()|
-- - 'gO' is mapped to |vim.lsp.buf.document_symbol()|
-- - CTRL-S (Insert mode) is mapped to |vim.lsp.buf.signature_help()|
-- - 'an' and 'in' (Visual and Operator-pending mode) are mapped to outer and inner incremental
--   selections, respectively, using |vim.lsp.buf.selection_range()|
vim.lsp.config['lua_ls'] = {
    -- sudo pacman -S lua-language-server
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        { '.luarc.json', '.luarc.jsonc', '.git' },
    },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            }
        }
    }
}
vim.lsp.enable('lua_ls')

vim.lsp.config['gopls'] = {
    -- go install golang.org/x/tools/gopls@latest
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod' },
    root_markers = { 'go.mod', 'go.work', '.git' },
    settings = {
        gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = {
                unusedparams = true,
                shadow = true,
            },
        },
    },
}
vim.lsp.enable('gopls')

vim.lsp.config['clangd'] = {
    -- sudo pacman -S clang
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_markers = { 'compile_commands.json', 'compile_flags.txt', '.clangd', '.git' },
}
vim.lsp.enable('clangd')
