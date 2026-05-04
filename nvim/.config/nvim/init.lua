vim.cmd('set tgc cul nowrap nu sb scs spr sta vb list cc=80 ts=4 sw=4 so=10 siso=10 path+=**')
vim.cmd('filetype plugin indent on')
vim.g.doge_enable_mappings = 0
vim.g.doge_doc_standard_python = 'google'

vim.pack.add({
	'https://github.com/catppuccin/nvim',
	'https://github.com/nvim-mini/mini.nvim',
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/kkoomen/vim-doge', --TODO: doge#install() automation, or saying fuck it and changing the plugin
})

vim.diagnostic.config({ virtual_text = true, signs = true, severity_sort = true })

-- mini.nvim config
Minis = {'files', 'move', 'pairs', 'surround', 'icons', 'statusline', 'tabline', 'bracketed', 'git', 'diff'}
for _, m in ipairs(Minis) do
	require('mini.' .. m).setup()
end


-- commands
vim.cmd('colorscheme catppuccin')
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>f', ':lua MiniFiles.open()<CR>')
vim.keymap.set('n', '<leader>t', ':80vsplit | te<CR>')
vim.keymap.set('n', '<leader>b', ':lua require("mini.git").show_at_cursor()<CR>')
vim.keymap.set("n", "<leader>c", "<Plug>(doge-generate)")

-- LSP config: lua
vim.lsp.config("lua_ls", {
	filetypes = { "lua" },
	settings = {
		telemetry = {enable = false},
		Lua = {
			diagnostics = {globals = { "vim" },},
			workspace = { library = { "${3rd}/love2d/library"
},},},},})

-- LSP config: typst
vim.lsp.config("tinymist", {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	settings = {
		formatterMode = "typstyle",
},})

-- LSP loading
for k, v in pairs({
	pyright = { "python" },
	lua_ls = { "lua" },
	clangd = { "c", "cpp" },
}) do
	vim.lsp.config(k, { filetypes = v })
	vim.lsp.enable(k)
end
