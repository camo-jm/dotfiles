vim.cmd('set tgc cul nowrap nu sb scs spr sta vb et list cc=80 ts=4 sw=4 so=10 siso=10 path+=** icm=split')
vim.cmd('filetype plugin indent on')
vim.diagnostic.config({ virtual_text = true, signs = true, severity_sort = true })

vim.pack.add({
	'https://github.com/catppuccin/nvim',
	'https://github.com/nvim-mini/mini.nvim',
	'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    --'https://github.com/phrmendes/todotxt.nvim', --TODO: fix this or find an alternative
    'https://github.com/kkoomen/vim-doge', --TODO: doge#install() automation, or saying fuck it and changing the plugin
})

MINIS = {'files', 'move', 'pairs', 'surround', 'icons', 'statusline', 'tabline', 'bracketed', 'git', 'diff'}
ENSURE_LSP = {'zls', 'lua-language-server', 'clangd', 'pyright'}
ENABLE_LSP = {'zls', 'lua_ls', 'clangd', 'pyright'}


-- commands
vim.cmd('colorscheme catppuccin')
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>f', ':lua MiniFiles.open()<CR>')
vim.keymap.set('n', '<leader>t', ':80vsplit | te<CR>')
vim.keymap.set('n', '<leader>b', ':lua require("mini.git").show_at_cursor()<CR>')
vim.keymap.set('n', '<leader>c', '<Plug>(doge-generate)')
vim.g.doge_enable_mappings = 0
vim.g.doge_doc_standard_python = 'google'


-- plugins config
for _, m in ipairs(MINIS) do
	require('mini.' .. m).setup()
end

require('mason').setup({ ensure_installed = ENSURE_LSP, })
for _, server in pairs(ENABLE_LSP) do vim.lsp.enable(server) end


-- LSP configs
vim.lsp.config('lua_ls', {
	filetypes = { 'lua' },
	settings = {
		telemetry = {enable = false},
		Lua = {
			diagnostics = {globals = { 'vim' },},
			workspace = { library = { '${3rd}/love2d/library'},},
},},})

vim.lsp.config('tinymist', {
	cmd = { 'tinymist' },
	filetypes = { 'typst' },
	settings = {
		formatterMode = 'typstyle',
},})
