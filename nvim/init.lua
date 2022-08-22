
-- SETTINGS

local g = vim.g
local o = vim.o

o.termguicolors = true

-- Decrease update time
o.timeoutlen = 500
o.updatetime = 200

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 8

-- Better editor UI
o.number = true
o.numberwidth = 5
o.relativenumber = true
o.signcolumn = 'auto'
o.cursorline = true

-- Better editing experience
o.expandtab = true
o.cindent = true

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false

-- Remember 50 items in commandline history
o.history = 50

-- Better buffer splitting
o.splitright = true
o.splitbelow = true

-- Preserve view while jumping
o.jumpoptions = 'view'

-- AFTER
g.tokyonight_transparent_sidebar = true
g.tokyonight_transparent = true
o.background = "dark"
vim.cmd('colorscheme tokyonight')


require('telescope').setup{
  defaults = {
    prompt_prefix = "$ "
  },
}
require('telescope').load_extension('fzf')
require("telescope").load_extension('file_browser')
-- require('telescope').load_extension('coc')
-- require('telescope').load_extension('')

-- PAKER
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  use 'wakatime/vim-wakatime'
  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.0',
-- or                            , branch = '0.1.x',
  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  use {'nvim-telescope/telescope-file-browser.nvim'}
  -- use {'neoclide/coc.nvim', branch = 'release'}
  -- use 'fannheyward/telescope-coc.nvim'
  end)
