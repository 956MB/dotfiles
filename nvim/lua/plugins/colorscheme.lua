-- [[ Colorscheme selection ]]
-- One of: kanso (previous theme) or matteblack (current, local fork of tahayvr/matteblack.nvim).
-- matteblack.nvim is a git submodule at nvim/lua/plugins/custom/matteblack.nvim, added to
-- the rtp in config/pack.lua. Edit colors on the submodule's 'edits' branch.
-- Uninstall: remove `rtp_add 'matteblack.nvim'` from pack.lua and deinit the submodule.
--
-- To switch back to kanso: comment `vim.cmd 'colorscheme matteblack'` below and
-- uncomment the kanso block.
-- [[ kanso.nvim (local fork, added to rtp in pack.lua) ]]
-- require('kanso').setup {
--     theme = 'zen',
--     background = {
--         dark = 'zen',
--     },
-- }
-- vim.cmd 'colorscheme kanso'

-- [[ matteblack.nvim (local fork via rtp, edited on the 'edits' branch) ]]
vim.cmd 'colorscheme matteblack'