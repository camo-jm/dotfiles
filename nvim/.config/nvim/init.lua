vim.cmd('set tgc cul nowrap nu sb sb scs spr sta vb list cc=80 ts=4 sw=4 so=10 siso=10 path+=**')

-- plugins
vim.pack.add({
	'https://github.com/catppuccin/nvim',
	'https://github.com/nvim-mini/mini.nvim',
	'https://github.com/neovim/nvim-lspconfig'
})

Minis = {'files', 'move', 'pairs', 'surround', 'icons', 'statusline', 'tabline', 'bracketed'}
for _, m in ipairs(Minis) do require('mini.' .. m).setup() end
vim.diagnostic.config({ virtual_text = true, signs = true, severity_sort = true })

vim.cmd('colorscheme catppuccin')
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>f', ':lua MiniFiles.open()<CR>')

-- LSP configs
-- lua
vim.lsp.config("lua_ls", {
	filetypes = { "lua" },
	settings = {
		telemetry = {enable = false},
		Lua = {
			diagnostics = {globals = { "vim" },},
			workspace = { library = { "${3rd}/love2d/library"
},},},},})

-- typst
vim.lsp.config("tinymist", {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	settings = {
		formatterMode = "typstyle",
},})

-- loading the necessary LSPs
for k, v in pairs({
	pyright = { "python" },
	lua_ls = { "lua" },
	clangd = { "c", "cpp" },
}) do
	vim.lsp.config(k, { filetypes = v })
	vim.lsp.enable(k)
end
