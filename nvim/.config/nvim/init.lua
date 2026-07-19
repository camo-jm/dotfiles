vim.cmd('set tgc cul nowrap nu sb scs spr sta vb et list cc=80 ts=4 sw=4 so=10 siso=10 path+=** icm=split') --cuc
vim.cmd('filetype plugin indent on')
vim.diagnostic.config({ virtual_text = true, signs = true, severity_sort = true })

vim.pack.add({
    'https://github.com/nvim-mini/mini.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/phrmendes/todotxt.nvim',
    'https://github.com/bkp5190/rduck.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/RRethy/base16-nvim',
    'https://github.com/David-Kunz/gen.nvim', --TODO setup
})

MINIS = {'files', 'move', 'pairs', 'surround', 'icons', 'statusline', 'tabline', 'bracketed', 'git', 'diff', 'hipatterns', 'cursorword', 'starter', 'operators'} --clue
-- TODO: MAYBE: reformat this, define a dict for each file type with all things needed
LSP = {'zls', 'lua_ls', 'clangd', 'pyright'}

-- commands
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>f', ':lua MiniFiles.open()<CR>')
vim.keymap.set('n', '<leader>t', ':80vsplit | te<CR>')
vim.keymap.set('n', '<leader>b', ':lua require("mini.git").show_at_cursor()<CR>')
vim.keymap.set('n', '<leader>l', ':TodoTxt<CR>')
vim.keymap.set('n', '<leader>a', ':TodoTxt new<CR>')
vim.keymap.set('n', '<leader>c', ':DoneTxt<CR>')
vim.keymap.set('n', '<leader>d', '<cmd>Duck<CR>')
-- TODO: '<leader>i', instruct llm, shows in 80vsp|te<CR>, can save it, etc

-- mini.nvim config
for _, m in ipairs(MINIS) do
	require('mini.' .. m).setup()
end

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
    todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
    note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
    -- TODO MAINFX
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },})

-- todotxt.nvim setup
vim.filetype.add({
    filename = {["todo.txt"] = "todotxt", ["done.txt"] = "todotxt"},})
require("todotxt").setup({
    todotxt = vim.env.HOME .. "/Documents/todo.txt",
    donetxt = vim.env.HOME .. "/Documents/done.txt",
    prefix = " ",
    highlight = "Comment",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "todotxt",
	callback = function(event)
		vim.keymap.set("n", "<leader>x", function()
			vim.lsp.buf.code_action({
				filter = function(action)
					return action.title:match("Toggle done") ~= nil
				end,
				apply = true,
			})
		end, { buffer = event.buf, desc = "Toggle task done" })
	end,
})

-- treesitter
local ts = require('nvim-treesitter')
ts.install({ 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline', 'todotxt' }):wait(30000)

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
	callback = function(event)
		local lang = event.match
		local ok, task = pcall(ts.install, { lang })
		if ok then task:wait(10000) end
		pcall(vim.treesitter.start, event.buf, lang)
	end,
})

-- mason + LSPs setup
require('mason').setup()
require('mason-lspconfig').setup({ ensure_installed = LSP, })

for _, server in ipairs(LSP) do vim.lsp.enable(server) end

vim.lsp.config('lua_ls', {
	filetypes = { 'lua' },
	settings = {
		telemetry = {enable = false},
		Lua = {
			diagnostics = {globals = { 'vim' },},
			workspace = { library = { '${3rd}/love2d/library'},},
},},})
-- noctalia things

local ok, matugen = pcall(require, 'matugen')
if ok then matugen.setup() end
