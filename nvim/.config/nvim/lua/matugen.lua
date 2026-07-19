 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#1e2320',
    base01 = '#272e2a',
    base02 = '#303934',
    base03 = '#636e66',
    base04 = '#9da49a',
    base05 = '#d3cdc3',
    base06 = '#d3cdc3',
    base07 = '#d3cdc3',
    base08 = '#c27979',
    base09 = '#7f9193',
    base0A = '#cb9b7c',
    base0B = '#8da383',
    base0C = '#96e0e9',
    base0D = '#b0e996',
    base0E = '#e9b696',
    base0F = '#682020',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#d3cdc3',          bg = '#1e2320' })
  hi('TelescopeBorder',         { fg = '#636e66',             bg = '#1e2320' })
  hi('TelescopePromptNormal',   { fg = '#d3cdc3',          bg = '#1e2320' })
  hi('TelescopePromptBorder',   { fg = '#636e66',             bg = '#1e2320' })
  hi('TelescopePromptPrefix',   { fg = '#8da383',             bg = '#1e2320' })
  hi('TelescopePromptCounter',  { fg = '#9da49a',  bg = '#1e2320' })
  hi('TelescopePromptTitle',    { fg = '#1e2320',             bg = '#8da383' })
  hi('TelescopePreviewTitle',   { fg = '#1e2320',             bg = '#cb9b7c' })
  hi('TelescopeResultsTitle',   { fg = '#1e2320',             bg = '#7f9193' })
  hi('TelescopeSelection',      { fg = '#d3cdc3',          bg = '#303934' })
  hi('TelescopeSelectionCaret', { fg = '#8da383',             bg = '#303934' })
  hi('TelescopeMatching',       { fg = '#8da383',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
