vim.g.mapleader = ' ' -- welcome to my quite compact nvim config!

vim.keymap.set('n', '<leader>f', ':lua MiniFiles.open()<CR>',                       {desc = 'file tree'})
vim.keymap.set('n', '<leader>t', ':80vsplit | te<CR>',                              {desc = 'terminal'})
vim.keymap.set('n', '<leader>b', ':lua require("mini.git").show_at_cursor()<CR>',   {desc = 'git history @line'})

vim.cmd('set tgc cul cuc nowrap nu sb scs spr sta vb list et sts=4 cc=80 ts=4 sw=2 so=10 siso=10 path+=** icm=split')
vim.cmd('filetype plugin indent on')
vim.diagnostic.config({ virtual_text = true, signs = true, severity_sort = true })
vim.g.vimwiki_list = {{path = "~/Media/Documents/notes", syntax = "markdown", ext = "md",}}


PLUGINS = true
SETUP = { -- try doing gS in normal mode, inside the brackets (you need mini.splitjoin)
  plugins = { --TODO check if it could be changed
    list = {'https://github.com/mason-org/mason-lspconfig.nvim', 'https://github.com/mason-org/mason.nvim', 'https://github.com/neovim/nvim-lspconfig', 'https://github.com/nvim-mini/mini.nvim', 'https://github.com/nvim-treesitter/nvim-treesitter', 'https://github.com/daedlock/matugen.nvim', 'https://github.com/RRethy/base16-nvim', 'https://github.com/hrsh7th/nvim-cmp', 'https://github.com/vimwiki/vimwiki',},
    setup = function() vim.pack.add(SETUP.plugins.list) end,
  },
  matugen = {
    plugin = pcall(require, 'matugen'),
    setup = function() local plug, matugen = pcall(require, 'matugen'); if plug then matugen.setup() end end
  },
  nvim_mini = { --TODO check if mini.git is really worth it (mini.diff colors lines btw)
    list = {'snippets', 'bracketed', 'clue', 'completion', 'cursorword', 'diff', 'files', 'git', 'hipatterns', 'icons', 'move', 'pairs', 'splitjoin', 'surround', 'tabline',},
    setup = function() for _, i in ipairs(SETUP.nvim_mini.list) do require("mini." .. i).setup() end end,
  },
  treesitter = {
    list = {'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline', 'todotxt', 'java'},
    setup = function() require('nvim-treesitter').install(SETUP.treesitter.list):wait(30000) end
  },
  mason = {
    list = {'bashls', 'clangd', 'expert', 'jdtls', 'lua_ls', 'pyright', 'zls', 'tinymist',},
    plugin = function() require('mason').setup() end,
    lspconfig = function() local list = SETUP.mason.list; require('mason-lspconfig').setup({ ensure_installed = list, automatic_enable = list }) end,
    setup = function() local mason = SETUP.mason; mason.plugin(); mason.lspconfig(); for _, server in ipairs(mason.list) do vim.lsp.enable(server); end end
  },
  example = {
    setup = function() end
  },
}

SETUP.plugins.setup()
if PLUGINS then for _, item in pairs(SETUP) do item.setup() end
else vim.cmd('colorscheme slate') end

--------------------------------------------------------------------------------
-- here are the very specific post-setup shenanigans ---------------------------
--------------------------------------------------------------------------------

pcall(vim.keymap.del, "i", "<C-j>") --FIXME this line shouldn't be necessary, this can certainly be fixed
require("mini.snippets").setup({
	snippets = {
		require('mini.snippets').gen_loader.from_file('~/.config/nvim/snippets/global.json')
	},
	mappings = {
		expand = "<C-e>",
		jump_next = "<C-b>",
		jump_prev = "",
		stop = "",
	},})

require('mini.hipatterns').setup({
	highlighters = {
		fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
		hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
		todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
		note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
		hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
	},})

vim.api.nvim_create_autocmd('FileType', { -- treesitter autoinstall
	group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
	callback = function(event)
		local lang = event.match
		local ok, task = pcall(require('nvim-treesitter').install, { lang })
		if ok then task:wait(10000) end
		pcall(vim.treesitter.start, event.buf, lang)
	end,
})

local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    {mode = {'n', 'v'}, keys = '<leader>'},
  }
})

vim.lsp.config('lua_ls', {
  filetypes = { 'lua' },
  settings = {
    telemetry = {enable = false},
    Lua = {
      diagnostics = {globals = { 'vim' },},
      workspace = { library = { '${3rd}/love2d/library'},},
    },},})

-- maybe? ----------------------------------------------------------------------

-- -- TODO
-- vim.keymap.set('i', '<C-space>', function()
--   local line = vim.api.nvim_get_current_line()
--   local col = vim.api.nvim_win_get_cursor(0)[2]
--   local str_before = line:sub(1, col)
-- 
--   -- Extract pattern up to the cursor (e.g., looking for something like "obj_")
--   local prefix = str_before:match("([%w_]+_)$")
--   if not prefix then return end
-- 
--   -- Scan current buffer lines for words following the pattern
--   local words = {}
--   local seen = {}
--   for _, l in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
--     for match in l:gmatch(prefix .. "(%w+)") do
--       if not seen[match] then
--         seen[match] = true
--         table.insert(words, match)
--       end
--     end
--   end
--
--   vim.fn.complete(col - #prefix + 1, words)
-- end, { expr = false, silent = true })
-- -- TODO

-- SETUP.plugins:
-- -- setup -> install
    -- setup = function() for _, plugin in ipairs(SETUP.plugins.list) then if pcall(require .. plugin) end end end

    -- local ok, matugen = pcall(require, 'matugen')
    -- if ok then matugen.setup() end
