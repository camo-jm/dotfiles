-- try doing gS in normal mode, inside the brackets (you need mini.splitjoin)
vim.pack.add({'https://github.com/catppuccin/nvim', 'https://github.com/mason-org/mason-lspconfig.nvim', 'https://github.com/mason-org/mason.nvim', 'https://github.com/neovim/nvim-lspconfig', 'https://github.com/nvim-mini/mini.nvim', 'https://github.com/nvim-treesitter/nvim-treesitter', 'https://github.com/phrmendes/todotxt.nvim', 'https://github.com/shaunsingh/nord.nvim', 'https://github.com/daedlock/matugen.nvim', 'https://github.com/RRethy/base16-nvim',})
MINIS = {'bracketed', 'clue', 'completion', 'cursorword', 'diff', 'files', 'git', 'hipatterns', 'icons', 'move', 'operators', 'pairs', 'snippets', 'splitjoin', 'starter', 'statusline', 'surround', 'tabline',} --base16 maybe?
TREESITTER = {'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline', 'todotxt', 'java'}
LSP = {'bashls', 'clangd', 'expert', 'jdtls', 'lua_ls', 'pyright', 'zls',}
COLORSCHEME = "catppuccin"

vim.g.mapleader = ' '
vim.keymap.set('n',	'<leader>f',		':lua MiniFiles.open()<CR>',								{desc = 'file tree'})
vim.keymap.set('n',	'<leader>t',		':80vsplit | te<CR>',										{desc = 'terminal'})
vim.keymap.set('n',	'<leader><S-t>',	':te<CR>',													{desc = 'fullscreen terminal'})
vim.keymap.set('n',	'<leader>b',		':lua require("mini.git").show_at_cursor()<CR>',			{desc = 'git history @line'})
vim.keymap.set('n',	'<leader>l',		':TodoTxt<CR>',												{desc = 'todo file'})
vim.keymap.set('n',	'<leader>a',		':TodoTxt new<CR>',											{desc = 'add task'})
vim.keymap.set('n',	'<leader>d',		'<cmd>echo("(- > -) <(explain it, i\'m all ears)")<CR>',	{desc = 'the duck.'})

vim.keymap.set('v', '<leader>g', function()
	vim.cmd('80vsp | te')
	local buf = vim.api.nvim_get_current_buf()
	local chan = vim.b[buf].terminal_job_id
	vim.api.nvim_chan_send(chan, "echo 'beep boop'\n")
end, { desc = 'WIP: AI stuff' }) -- TODO

vim.cmd('set tgc cul cuc nowrap nu sb scs spr sta vb list sts=4 cc=80 ts=4 sw=4 so=10 siso=10 path+=** icm=split')
vim.cmd('filetype plugin indent on')
vim.diagnostic.config({ virtual_text = true, signs = true, severity_sort = true })

--------------------------------------------------------------------------------
-- here starts the "backend" so to speak ---------------------------------------
--------------------------------------------------------------------------------

-- noctalia thingies
local ok, matugen = pcall(require, 'matugen')
if ok then matugen.setup() end

-- mini.nvim config
for _, m in ipairs(MINIS) do
	require('mini.' .. m).setup()
end

local miniclue = require('mini.clue')
miniclue.setup({
	triggers = {
		{mode = {'n', 'v'}, keys = '<leader>'},
	}
})

local snippets = require('mini.snippets')
snippets.setup({
	snippets = {
		require("mini.snippets").gen_loader.from_lang(),
	},
})

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
	highlighters = {
		fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
		hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
		todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
		note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
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
ts.install(TREESITTER):wait(30000)

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

vim.cmd("colorscheme " .. COLORSCHEME)
