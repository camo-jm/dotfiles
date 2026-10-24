-- try doing gS in normal mode, inside the brackets (you need mini.splitjoin)
vim.pack.add({'https://github.com/catppuccin/nvim', 'https://github.com/mason-org/mason-lspconfig.nvim', 'https://github.com/mason-org/mason.nvim', 'https://github.com/neovim/nvim-lspconfig', 'https://github.com/nvim-mini/mini.nvim', 'https://github.com/nvim-treesitter/nvim-treesitter', 'https://github.com/daedlock/matugen.nvim', 'https://github.com/RRethy/base16-nvim', 'https://github.com/hrsh7th/nvim-cmp',}) --check: catppuccin, gen.nvim

MINIS = {'snippets', 'bracketed', 'clue', 'completion', 'cursorword', 'diff', 'files', 'git', 'hipatterns', 'icons', 'move', 'pairs', 'splitjoin', 'surround', 'tabline',} --check: bracketed, cursorword, git, icons, pairs, splitjoin, surround
TREESITTER = {'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline', 'todotxt', 'java'}
LSP = {'bashls', 'clangd', 'expert', 'jdtls', 'lua_ls', 'pyright', 'zls', 'tinymist',}
--COLORSCHEME = "catppuccin"
vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>f',        ':lua MiniFiles.open()<CR>',                                {desc = 'file tree'})
vim.keymap.set('n', '<leader>t',        ':80vsplit | te<CR>',                                       {desc = 'terminal'})
vim.keymap.set('n', '<leader>b',        ':lua require("mini.git").show_at_cursor()<CR>',            {desc = 'git history @line'}) --TODO checkme

vim.cmd('set tgc cul cuc nowrap nu sb scs spr sta vb list et sts=4 cc=80 ts=4 sw=2 so=10 siso=10 path+=** icm=split')
vim.cmd('filetype plugin indent on')
vim.diagnostic.config({ virtual_text = true, signs = true, severity_sort = true })

--------------------------------------------------------------------------------
-- here starts the "backend" so to speak ---------------------------------------
--------------------------------------------------------------------------------

vim.keymap.set('i', '<C-space>', function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local str_before = line:sub(1, col)

  -- Extract pattern up to the cursor (e.g., looking for something like "obj_")
  local prefix = str_before:match("([%w_]+_)$")
  if not prefix then return end

  -- Scan current buffer lines for words following the pattern
  local words = {}
  local seen = {}
  for _, l in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    for match in l:gmatch(prefix .. "(%w+)") do
      if not seen[match] then
        seen[match] = true
        table.insert(words, match)
      end
    end
  end

  -- Trigger Neovim's native completion popup
  vim.fn.complete(col - #prefix + 1, words)
end, { expr = false, silent = true })

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

pcall(vim.keymap.del, "i", "<C-j>") --NOTE unfortunately this has to be done since the plugin is required twice (i'm gonna fix it later)

local gen_loader = require('mini.snippets').gen_loader
require("mini.snippets").setup({
	snippets = {
		gen_loader.from_file('~/.config/nvim/snippets/global.json')
	},
	mappings = {
		expand = "<C-e>",
		jump_next = "<C-b>",
		jump_prev = "",
		stop = "",
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

for _, server in ipairs(LSP) do vim.lsp.enable(server) end --TODO make this only load necessary LSPs

vim.lsp.config('lua_ls', {
	filetypes = { 'lua' },
	settings = {
		telemetry = {enable = false},
		Lua = {
			diagnostics = {globals = { 'vim' },},
			workspace = { library = { '${3rd}/love2d/library'},},
},},})

if COLORSCHEME then vim.cmd("colorscheme " .. COLORSCHEME) end
