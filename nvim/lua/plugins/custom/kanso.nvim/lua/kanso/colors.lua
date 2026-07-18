---@class PaletteColors
local palette = {

    -- Bg Shades
    zen0 = '#181818',
    zen1 = '#252525',
    zen2 = '#2D2D2D',
    zen3 = '#424242',

    -- Popup and Floats
    zenBlue1 = '#162b49',
    zenBlue2 = '#1c4867',

    -- Diff and Git
    winterGreen = '#293325',
    winterYellow = '#494238',
    winterRed = '#431b24',
    winterBlue = '#202035',
    autumnGreen = '#6d945d',
    autumnRed = '#c3191d',
    autumnYellow = '#dc943c',

    -- Diag
    samuraiRed = '#e80000',
    roninYellow = '#ff8100',
    zenAqua1 = '#5d9585',
    inkBlue = '#578094',

    -- Fg and Comments
    oldWhite = '#C9C9C9',
    fujiWhite = '#F2F2F2',
    fujiGray = '#727272',

    oniViolet = '#8b6eb8',
    oniViolet2 = '#b1acd0',
    crystalBlue = '#638ad8',
    springViolet1 = '#8c81a9',
    springViolet2 = '#8ea2ca',
    springBlue = '#68adca',
    lightBlue = '#94d4d5',
    zenAqua2 = '#6ca89c',

    springGreen = '#8ebb54',
    boatYellow1 = '#937a44',
    boatYellow2 = '#c09a55',
    carpYellow = '#e6b867',

    sakuraPink = '#d26588',
    zenRed = '#e44355',
    peachRed = '#ff2c33',
    surimiOrange = '#ff8438',
    katanaGray = '#6e7c7c',

    inkBlack0 = '#1C1C1C',
    inkBlack1 = '#262626',
    inkBlack2 = '#2D2D2D',
    inkBlack3 = '#424242',

    inkWhite = '#CDCDCD', -- minor saturation increase (was already very desaturated)
    inkGreen = '#6eb575', -- more vibrant green
    inkGreen2 = '#83a765', -- richer green
    inkPink = '#a784ab', -- deeper pink
    inkOrange = '#cb7f4f', -- more vivid orange
    inkOrange2 = '#d1724d', -- brighter orange-red
    inkGray = '#a2aaa1', -- slightly more colorful gray
    inkGray1 = '#a69689', -- warmer gray
    inkGray2 = '#868686', -- bluer gray
    inkGray3 = '#6B6B6B', -- deeper slate
    inkBlue2 = '#71a7c1', -- more intense blue
    inkViolet = '#7289b6', -- richer violet
    inkRed = '#e03c30', -- much more vivid red
    inkAqua = '#7ab0a8', -- cleaner aqua
    inkAsh = '#52596a', -- same as inkGray3
    inkTeal = '#7c98c7', -- more vibrant teal/blue
    inkYellow = '#d9af54', -- brighter yellow
    -- "#8a9aa3",

    pearlInk0 = '#21242d',
    pearlInk1 = '#4f4f64',
    pearlInk2 = '#37376c',
    pearlGray = '#e2e1de',
    pearlGray2 = '#585e68',
    pearlGray3 = '#6d6d68',
    pearlGray4 = '#9f9f97',

    pearlWhite0 = '#f2f1ee',
    pearlWhite1 = '#e2e1de',
    pearlWhite2 = '#ddddda',
    pearlViolet1 = '#9c97ac',
    pearlViolet2 = '#6e6090',
    pearlViolet3 = '#c7c9d1',
    pearlViolet4 = '#583c83',
    pearlBlue1 = '#c0d4e0',
    pearlBlue2 = '#acc9d2',
    pearlBlue3 = '#92afc9',
    pearlBlue4 = '#365a9b',
    pearlBlue5 = '#4840a3',
    pearlGreen = '#67893c',
    pearlGreen2 = '#649150',
    pearlGreen3 = '#b0d0a4',
    pearlPink = '#b34168',
    pearlOrange = '#cc6d00',
    pearlOrange2 = '#e98a00',
    pearlYellow = '#776f2e',
    pearlYellow2 = '#836939',
    pearlYellow3 = '#de9800',
    pearlYellow4 = '#f9cd72',
    pearlRed = '#c81730',
    pearlRed2 = '#d71c21',
    pearlRed3 = '#e80000',
    pearlRed4 = '#d9957f',
    pearlAqua = '#4f7b73',
    pearlAqua2 = '#528577',
    pearlTeal1 = '#3585a2',
    pearlTeal2 = '#4b86bf',
    pearlTeal3 = '#4d7385',
    pearlCyan = '#d3e3d5',
}

local M = {}
--- Generate colors table:
--- * opts:
---   - colors: Table of personalized colors and/or overrides of existing ones.
---     Defaults to KansoConfig.colors.
---   - theme: Use selected theme. Defaults to KansoConfig.theme
---     according to the value of 'background' option.
---@param opts? { colors?: table, theme?: string }
---@return { theme: ThemeColors, palette: PaletteColors}
function M.setup(opts)
    opts = opts or {}
    local override_colors = opts.colors or require('kanso').config.colors
    local theme = opts.theme or require('kanso')._CURRENT_THEME -- WARN: this fails if called before kanso.load()

    if not theme then
        error "kanso.colors.setup(): Unable to infer `theme`. Either specify a theme or call this function after ':colorscheme kanso'"
    end

    -- Add to and/or override palette_colors
    local updated_palette_colors = vim.tbl_extend('force', palette, override_colors.palette or {})

    -- Generate the theme according to the updated palette colors
    local theme_colors = require('kanso.themes')[theme](updated_palette_colors)

    -- Add to and/or override theme_colors
    local theme_overrides = vim.tbl_deep_extend('force', override_colors.theme['all'] or {}, override_colors.theme[theme] or {})
    local updated_theme_colors = vim.tbl_deep_extend('force', theme_colors, theme_overrides)
    -- return palette_colors AND theme_colors

    return {
        theme = updated_theme_colors,
        palette = updated_palette_colors,
    }
end

return M
