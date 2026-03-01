v.o.number = true
v.o.relativenumber = true
v.o.cursorline = true
v.o.scrolloff = 999
v.o.wrap = false
v.o.incsearch = true

v.o.tabstop = 2
v.o.shiftwidth = 2
v.o.softtabstop = 2
v.o.expandtab = true

v.cmd("filetype plugin indent on")

v.g.loaded_netrw = 1
v.g.loaded_netrwPlugin = 1

v.g.mapleader = " "

v.keymap.set({ "n", "v" }, "<leader>y", "\"+y", { desc = "[Y]ank to system clipboard" })
v.keymap.set({ "n", "v" }, "<leader>p", "\"+p", { desc = "[P]aste from system clipboard" })

v.keymap.set("n", "<C-n>", ":botright vnew<CR>", { desc = "[N]ew vertical split" })
v.keymap.set("n", "<Tab>", ":wincmd w<CR>", { desc = "Next [W]indow" })
v.keymap.set("n", "<S-Tab>", ":wincmd r<CR>", { desc = "[R]otate windows" })

v.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search [H]ighlight" })

-- terminal mode
v.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
v.keymap.set("n", "<leader>T", ":botright 15split | lcd %:p:h | terminal<CR>", { desc = "[T]erminal"})

--
-- autocmd
--
v.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = v.fn.argv(0)
    if arg ~= "" and v.fn.isdirectory(arg) == 1 then
      v.cmd("Telescope file_browser path=" .. v.fn.fnameescape(arg))
    end
  end,
})

v.api.nvim_create_autocmd("TermOpen", {
  callback = function ()
    v.cmd("startinsert")
  end
})

--
-- plugins
--
local lazypath = v.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (v.uv or v.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = v.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if v.v.shell_error ~= 0 then
    v.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    v.fn.getchar()
    os.exit(1)
  end
end
v.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'wakatime/vim-wakatime', lazy = false
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup {
        styles = {
          comments = { italic = false },
        },
      }
      v.cmd.colorscheme "tokyonight-night"
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
            follow_symlinks = true,
            hijack_netrw = true,
          }
        }
      }

      v.keymap.set(
        "n",
        "<leader>fb",
        ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
        { desc = "[F]ile [B]rowser" }
      )

      local builtin = require("telescope.builtin")

      v.keymap.set(
        "n", "<leader>o",
        function()
          builtin.find_files{
            prompt_title = "find file",
          }
        end, { desc = "[O]pen files" }
      )

      v.keymap.set(
        "n", "<leader>gh",
        function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = "grep here",
          }
        end, { desc = "[G]rep [H]ere" }
      )

      -- Shortcut for searching your Neovim configuration files
      v.keymap.set(
        'n', '<leader>sn',
        function()
          builtin.find_files {
            cwd = v.fn.stdpath 'config'
          }
        end, { desc = '[S]earch [N]eovim files' })
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
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 0,
      icons = { mappings = v.g.have_nerd_font },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- LSP Plugins
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer

      -- Diagnostic keymaps
      v.keymap.set("n", "<leader>q", v.diagnostic.setloclist, { desc = "[Q]uickfix diagnostics list" })
        v.keymap.set("n", "<leader>df", v.diagnostic.open_float, { desc = "[D]iagnostic [F]loat" })
      v.api.nvim_create_autocmd('LspAttach', {
        group = v.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            v.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>lr', v.lsp.buf.rename, '[L]SP [R]ename')
          map('<leader>la', v.lsp.buf.code_action, '[L]SP Code [A]ction', { 'n', 'x' })
          map('<leader>lD', v.lsp.buf.declaration, '[L]SP [D]eclaration')
          map('<leader>ld', v.lsp.buf.definition, '[L]SP [D]efinition')
          map('<leader>li', v.lsp.buf.implementation, '[L]SP [I]mplementation')
          map('<leader>lt', v.lsp.buf.type_definition, '[L]SP [T]ype definition')
          map('<leader>lf', v.lsp.buf.references, '[L]SP [F]ind references')
          map('<leader>lh', v.lsp.buf.hover, '[L]SP [H]over')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = v.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = v.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            v.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = v.lsp.buf.document_highlight,
            })

            v.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = v.lsp.buf.clear_references,
            })

            v.api.nvim_create_autocmd('LspDetach', {
              group = v.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                v.lsp.buf.clear_references()
                v.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method('textDocument/inlayHint', event.buf) then
            map('<leader>th', function() v.lsp.inlay_hint.enable(not v.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --  See `:help lsp-config` for information about keys and how to configure
      local servers = {
        -- clangd = {},
        gopls = {
          gofmt = true,
        },
        -- pyright = {},
        -- rust_analyzer = {},
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      local ensure_installed = v.tbl_keys(servers or {})
      v.list_extend(ensure_installed, {
        'lua-language-server', -- Lua Language server
        -- 'gopls',
        -- 'rust_analyzer',
        -- You can add other tools here that you want Mason to install
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for name, server in pairs(servers) do
        server.capabilities = v.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        v.lsp.config(name, server)
        v.lsp.enable(name)
      end

      -- Special Lua Config, as recommended by neovim help docs
      v.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= v.fn.stdpath 'config' and (v.uv.fs_stat(path .. '/.luarc.json') or v.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
          end

          client.config.settings.Lua = v.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = { 'lua/?.lua', 'lua/?/init.lua' },
            },
            workspace = {
              checkThirdParty = false,
              -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
              --  See https://github.com/neovim/nvim-lspconfig/issues/3189
              library = v.api.nvim_get_runtime_file('', true),
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })
      v.lsp.enable 'lua_ls'
    end,
  },
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if v.fn.has 'win32' == 1 or v.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
    },
    --- @module 'blink.cmp'
    ---@diagnostic disable-next-line: undefined-doc-name
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
})
