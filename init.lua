vim.g.mapleader = ','

vim.o.number = true
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.showmode = false
vim.o.termguicolors = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.signcolumn = 'yes'
vim.o.mouse = 'a'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.clipboard = "unnamedplus"
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Basic clipboard interaction
vim.keymap.set({'n', 'x', 'o'}, 'gy', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({'n', 'x', 'o'}, 'gp', '"+p', { desc = 'Paste clipboard content' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit fast' })
vim.keymap.set('n', '<leader>w', '<cmd>wq<CR>', { desc = 'Save and quit fast' })
vim.keymap.set('n', '<C-j>', 'ddp', { desc = 'Move line down' })
vim.keymap.set('n', '<C-k>', 'ddkP', { desc = 'Move line up' })

-- Neovim v0.11 is still under development
-- we will use this to enable certain features
local is_v11 = vim.fn.has('nvim-0.11') == 1

local lazy = {}

function lazy.install(path)
  if not vim.uv.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  if vim.g.plugins_ready then
    return
  end

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end

lazy.path = vim.fs.joinpath(vim.fn.stdpath('data') --[[@as string]], 'lazy', 'lazy.nvim')
lazy.opts = {}

lazy.setup({
  {'folke/tokyonight.nvim'},
  {'folke/which-key.nvim'},
  --{'neovim/nvim-lspconfig'},
  {'nvim-treesitter/nvim-treesitter'},
  {'nvim-tree/nvim-tree.lua'},
  {
   'nvim-telescope/telescope.nvim', tag = '0.1.8',
     dependencies = {
       'nvim-lua/plenary.nvim',
     },
  },
})

vim.cmd.colorscheme('tokyonight-storm')

require('nvim-treesitter.configs').setup({
  highlight = {enable = true,},
  auto_install = true,
  ensure_installed = {'lua', 'vim', 'json'},
})

require('which-key').setup({
  icons = {
    mappings = false,
    keys = {
      Space = 'Space',
      Esc = 'Esc',
      BS = 'Backspace',
      C = 'Ctrl-',
    },
  },
})

require('which-key').add({
  {'<leader>f', group = 'Fuzzy Find'},
  {'<leader>b', group = 'Buffer'},
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)

    local client_id = vim.tbl_get(event, 'data', 'client_id')
    local client = client_id and vim.lsp.get_client_by_id(client_id)

    -- enable completion side effects (if possible)
    -- note is only available in neovim v0.11 or greater
    if is_v11 and client and client.supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client_id, event.buf, {})
    end
  end,
})

if vim.fn.executable("clangd") == 1 then
    local clangd_lsp = vim.api.nvim_create_augroup("clangd_lsp", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        callback = function()
            local root_dir = vim.fs.dirname(vim.fs.find({
                ".clangd",
                ".clang-tidy",
                ".clang-format",
                "compile_commands.json",
                "compile_flags.txt",
                "configure.ac",
                ".git",
            }, { upward = true, path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) })[1])
            local client = vim.lsp.start({
                name = "clangd",
                cmd = { "clangd" },
                root_dir = root_dir,
                single_file_support = true,
                capabilities = {
                    textDocument = {
                        completion = {
                            editsNearCursor = true,
                        },
                    },
                    offsetEncoding = { "utf-8", "utf-16" },
                },
            })
            -- vim.lsp.buf_attach_client(0, client)
        end,
        group = clangd_lsp,
    })
end

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

require("nvim-tree").setup()
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>')
