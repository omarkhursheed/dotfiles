" Basic settings
set number
set relativenumber
set expandtab
set shiftwidth=2
set softtabstop=2
set mouse=a
set clipboard+=unnamedplus
syntax on
filetype plugin indent on

" Set leader key
let mapleader = " "

" Plugins
call plug#begin('~/.config/nvim/plugged')
" Theme
Plug 'folke/tokyonight.nvim'

" Status line
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" File explorer
Plug 'nvim-tree/nvim-tree.lua'

" Fuzzy finder
Plug 'nvim-lua/plenary.nvim'  " Required dependency for telescope
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }

" Treesitter for better syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'}
Plug 'williamboman/mason-lspconfig.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
call plug#end()

" Set colorscheme
colorscheme tokyonight-night

" Quick actions (Space + key)
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :NvimTreeToggle<CR>
nnoremap <Esc> :nohlsearch<CR>

" Window navigation (Ctrl + hjkl)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" File explorer and search
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>

" LSP keybindings
nnoremap <leader>gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>d <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap [d <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap ]d <cmd>lua vim.diagnostic.goto_next()<CR>

" Mason keybinding
nnoremap <leader>m <cmd>Mason<CR>

" Simple Lua setup
lua << EOF
-- Setup lualine with a proper theme
require('lualine').setup({
  options = {
    theme = 'tokyonight',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
  }
})

-- Configure nvim-tree with on_attach
require('nvim-tree').setup({
  auto_reload_on_write = true,
  disable_netrw = true,
  hijack_cursor = true,
  hijack_netrw = true,
  sort_by = "name",
  sync_root_with_cwd = true,
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')
    
    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Apply default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- Add custom mappings
    vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
    vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
    vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
  end,
  view = {
    width = 30,
    side = "left",
    signcolumn = "yes",
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
    ignore = true,
  },
  actions = {
    open_file = {
      quit_on_open = false,
      resize_window = true,
    },
  },
})

-- Telescope setup is now in after/plugin/telescope_fix.lua

-- Configure Treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = { "lua", "vim", "vimdoc", "python", "javascript", "typescript", "json" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-- Basic LSP setup in init.vim, more detailed setup in after/plugin files
-- This ensures everything is loaded properly

-- Mason setup for package management
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
  mason.setup()
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_ok then
  mason_lspconfig.setup({
    ensure_installed = { "lua_ls", "pyright", "ts_ls", "jsonls" },
    automatic_installation = true,
  })
end

-- Basic lspconfig setup - more comprehensive setup in after/plugin
local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
if lspconfig_ok then
  -- Get capabilities from cmp_nvim_lsp if available
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  
  local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if cmp_nvim_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities()
  end
  
  -- Setup language servers
  local servers = { "lua_ls", "pyright", "ts_ls", "jsonls" }
  for _, server in ipairs(servers) do
    lspconfig[server].setup({
      capabilities = capabilities
    })
  end
end
EOF
