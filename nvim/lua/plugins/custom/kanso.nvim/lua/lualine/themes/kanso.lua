local theme = require("kanso.colors").setup().theme

local kanso = {}

kanso.normal = {
    a = { fg = theme.syn.fun, bg = theme.ui.bg },
    b = { bg = theme.ui.none, fg = theme.syn.fun },
    c = { bg = theme.ui.none, fg = theme.ui.fg },
}

kanso.insert = {
    a = { fg = theme.diag.ok, bg = theme.ui.bg },
    b = { bg = theme.ui.none, fg = theme.diag.ok },
}

kanso.command = {
    a = { fg = theme.syn.operator, bg = theme.ui.bg },
    b = { bg = theme.ui.none, fg = theme.syn.operator },
}

kanso.visual = {
    a = { fg = theme.syn.keyword, bg = theme.ui.bg },
    b = { bg = theme.ui.none, fg = theme.syn.keyword },
}

kanso.replace = {
    a = { fg = theme.syn.constant, bg = theme.ui.bg },
    b = { bg = theme.ui.none, fg = theme.syn.constant },
}

kanso.inactive = {
    a = { bg = theme.ui.none, fg = theme.ui.cursor_line_nr_foreground },
    b = { bg = theme.ui.none, fg = theme.ui.cursor_line_nr_foreground },
    c = { bg = theme.ui.none, fg = theme.ui.cursor_line_nr_foreground },
}

if vim.g.kanso_lualine_bold then
    for _, mode in pairs(kanso) do
        mode.a.gui = "bold"
    end
end

return kanso
