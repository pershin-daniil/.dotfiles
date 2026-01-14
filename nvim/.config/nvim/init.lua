---@diagnostic disable: undefined-global

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.scrolloff = 999
vim.o.wrap = false
vim.o.incsearch = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y")
vim.keymap.set({ "n", "v" }, "<leader>p", "\"+p")

vim.keymap.set("n", "<C-n>", ":botright vnew<CR>")
vim.keymap.set("n", "<Tab>", ":wincmd w<CR>")
vim.keymap.set("n", "<S-Tab>", ":wincmd r<CR>")

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

--
-- autocmd
--
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
      vim.cmd("Telescope file_browser path=" .. vim.fn.fnameescape(arg))
    end
  end,
})

--
-- plugins
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup {
				styles = {
					comments = { italic = false },
				},
			}
			vim.cmd.colorscheme "tokyonight-night"
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim"
		},
		config = function()
			require("telescope").setup {
				extensions = {
					file_browser = {
						hidden = { file_browser = true, folder_browser = true },
						hijack_netrw = true,
					}
				}
			}
			vim.keymap.set("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>o", builtin.find_files)
			vim.keymap.set("n", "<leader>fs", builtin.live_grep)
		end
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup{}
		end
	},
	-- Git 
	{
		"tpope/vim-fugitive"
	},
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},
	-- LSP Plugins
	{
   "mason-org/mason-lspconfig.nvim",
   opts = {
    ensure_installed = { "lua_ls", "rust_analyzer" },
   },
   dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
   },
  },
})
