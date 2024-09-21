return {
    { -- syntax highlighting for kitty.conf
        'fladson/vim-kitty',
    },
    { -- Color scheme
        -- 'Mofiqul/vscode.nvim',
        dir = '~/dotfiles/nvim/lua/plugins/custom/vscode.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            local my_bg = '#181818'
            local vscode = require 'vscode'
            local c = require('vscode.colors').get_colors()

            vscode.setup {
                disable_nvimtree_bg = true,

                color_overrides = {
                    lualineBg = '#262626',
                    lualineBg2 = '#262626',
                    vscDiffRedDark = '#2B0D0D',
                    vscDiffRedLight = '#400B0B',
                    vscDiffRedLightLight = '#910101',
                    vscDiffGreenDark = '#202317',
                    vscDiffGreenLight = '#2B311C',
                },

                -- lualine_overrides = {
                --     normal = {
                --         a = { fg = c.vscFront, bg = '#121212', gui = 'bold' },
                --     },
                -- },

                group_overrides = {
                    VertSplit = { fg = c.vscSplitDark, bg = my_bg },
                    WinBar = { bg = my_bg, fg = my_bg },
                    WinBarNC = { bg = my_bg, fg = my_bg },
                    Normal = { fg = c.vscFront, bg = my_bg },
                    NormalNC = { fg = c.vscFront, bg = my_bg },
                    NormalFloat = { bg = my_bg },
                    SignColumn = { bg = my_bg },
                    Delimiter = { fg = '#444444', bg = my_bg },

                    -- quicker.nvim (quickfix)
                    QuickFixHeaderHard = { fg = '#444444', bg = my_bg },
                    QuickFixHeaderSoft = { fg = '#444444', bg = my_bg },
                    QuickFixFilename = { bg = my_bg, fg = c.vscBlue },

                    -- Line numbers and whitespace
                    LineNr = { fg = '#444444', bg = my_bg },
                    CursorLineNr = { fg = '#AFAFAF', bg = my_bg },
                    Whitespace = { fg = '#404040', bg = 'NONE' },

                    -- Syntax
                    MiniIndentscopeSymbol = { fg = '#707070', bg = 'NONE' },
                    Keyword = { fg = c.vscPink, bg = 'NONE' },
                    Directory = { fg = c.vscBlue, bg = c.vscBack },
                    Special = { fg = c.vscYellowOrange, bg = 'NONE' },
                    Comment = { fg = '#666666', bg = 'NONE' },
                    SpecialComment = { fg = '#666666', bg = 'NONE' },
                    ['@comment'] = { fg = '#666666', bg = 'NONE' },

                    -- Scrollbar
                    ScrollbarHandle = { bg = '#262626', fg = 'NONE' },
                    ScrollbarCursorHandle = { bg = '#262626', fg = 'NONE' },
                    ScrollbarWarn = { bg = 'NONE', fg = '#FFDF88' },
                    ScrollbarError = { bg = 'NONE', fg = '#FFBDB7' },
                    ScrollbarHint = { bg = 'NONE', fg = '#97DDFF' },
                    ScrollbarWarnHandle = { bg = '#262626', fg = '#FFDF88' },
                    ScrollbarErrorHandle = { bg = '#262626', fg = '#FFBDB7' },
                    ScrollbarHintHandle = { bg = '#262626', fg = '#97DDFF' },
                    ScrollbarGitAdd = { bg = 'NONE', fg = '#262626' },
                    ScrollbarGitChange = { bg = 'NONE', fg = '#262626' },
                    ScrollbarGitDelete = { bg = 'NONE', fg = '#262626' },
                    ScrollbarGitAddHandle = { bg = '#262626', fg = '#262626' },
                    ScrollbarGitChangeHandle = { bg = '#262626', fg = '#262626' },
                    ScrollbarGitDeleteHandle = { bg = '#262626', fg = '#262626' },

                    -- Lazygit
                    LazyGitFloat = { bg = 'NONE', fg = '#808080' },
                    LazyGitBorder = { bg = 'NONE', fg = '#808080' },

                    -- Git signs
                    GitSignsAdd = { bg = 'NONE', fg = '#2DA042' },
                    GitSignsChange = { bg = 'NONE', fg = c.vscBlue },
                    GitSignsDelete = { bg = 'NONE', fg = c.vscRed },

                    -- NvimTree
                    NvimTreeRootFolder = { fg = c.vscFront, bg = 'NONE', bold = true },
                    NvimTreeImageFile = { fg = c.vscViolet, bg = 'NONE' },
                    NvimTreeEmptyFolderName = { fg = c.vscGray, bg = 'NONE' },
                    NvimTreeFolderName = { fg = c.vscFront, bg = 'NONE' },
                    NvimTreeSpecialFile = { fg = c.vscPink, bg = 'NONE', underline = true },
                    NvimTreeNormal = { fg = c.vscFront, bg = my_bg },
                    NvimTreeCursorLine = { fg = 'NONE', bg = '#262626' },
                    NvimTreeVertSplit = { fg = c.vscSplitDark, bg = my_bg },
                    NvimTreeEndOfBuffer = { fg = my_bg },
                    NvimTreeOpenedFolderName = { fg = 'NONE', bg = my_bg },
                    NvimTreeGitRenamed = { fg = c.vscGitRenamed, bg = 'NONE' },
                    NvimTreeGitIgnored = { fg = c.vscGitIgnored, bg = 'NONE' },
                    NvimTreeGitDeleted = { fg = c.vscGitDeleted, bg = 'NONE' },
                    NvimTreeGitStaged = { fg = c.vscGitStageModified, bg = 'NONE' },
                    NvimTreeGitMerge = { fg = c.vscGitUntracked, bg = 'NONE' },
                    NvimTreeGitDirty = { fg = c.vscGitModified, bg = 'NONE' },
                    NvimTreeGitNew = { fg = c.vscGitAdded, bg = 'NONE' },

                    -- BufferLine
                    BufferLineFill = { bg = '#0D0D0D' },
                    BufferLineIndicatorSelected = { fg = '#606060', bg = 'NONE' },

                    -- Diffview
                    DiffviewNormal = { fg = c.vscFront, bg = my_bg },
                    DiffviewCursorLine = { bg = c.vscCursorDarkDark },
                    DiffviewVertSplit = { fg = c.vscSplitDark, bg = my_bg },
                    DiffviewStatusLine = { fg = c.vscFront, bg = c.vscLeftDark },
                    DiffviewStatusLineNC = { fg = c.vscFrontDark, bg = c.vscLeftDark },
                    DiffviewFilePanelTitle = { fg = c.vscLightBlue, bg = 'NONE', bold = true },
                    DiffviewFilePanelCounter = { fg = c.vscBlue, bg = 'NONE', bold = true },
                    DiffviewFilePanelFileName = { fg = c.vscFront, bg = 'NONE' },
                    DiffviewFilePanelPath = { fg = c.vscFrontDark, bg = 'NONE' },
                    DiffviewFilePanelInsertions = { fg = c.vscGitAdded, bg = 'NONE' },
                    DiffviewFilePanelDeletions = { fg = c.vscGitDeleted, bg = 'NONE' },
                    DiffviewStatusAdded = { fg = c.vscGitAdded, bg = my_bg },
                    DiffviewStatusUntracked = { fg = c.vscGitAdded, bg = my_bg },
                    DiffviewStatusModified = { fg = c.vscGitModified, bg = my_bg },
                    DiffviewStatusRenamed = { fg = c.vscGitRenamed, bg = my_bg },
                    DiffviewStatusDeleted = { fg = c.vscGitDeleted, bg = my_bg },

                    -- oil.nvim
                    OilDir = { fg = c.vscBlue, bg = 'NONE' }, -- links to Directory
                    OilDirIcon = { fg = c.vscYellowOrange, bg = 'NONE' }, -- links to Special
                    OilSocket = { fg = c.vscPink, bg = 'NONE' }, -- links to Keyword
                    OilLink = { fg = c.vscPink, bg = 'NONE' }, -- links to Keyword
                    OilLinkTarget = { fg = '#666666', bg = 'NONE' }, -- links to Comment
                    OilFile = { fg = c.vscFront, bg = 'NONE' }, -- links to Normal
                    OilCreate = { fg = c.vscGreen, bg = 'NONE' }, -- links to DiffAdd
                    OilDelete = { fg = c.vscRed, bg = 'NONE' }, -- links to DiffDelete
                    OilMove = { fg = c.vscYellow, bg = 'NONE' }, -- links to DiffChange
                    OilCopy = { fg = c.vscGreen, bg = 'NONE' }, -- links to DiffAdd
                    OilChange = { fg = c.vscYellow, bg = 'NONE' }, -- links to DiffChange
                    OilRestore = { fg = c.vscYellowOrange, bg = 'NONE' }, -- links to Special
                    OilPurge = { fg = c.vscRed, bg = 'NONE' }, -- links to DiffDelete
                    OilTrash = { fg = c.vscRed, bg = 'NONE' }, -- links to DiffDelete
                    OilTrashSourcePath = { fg = '#666666', bg = 'NONE' }, -- links to Comment

                    -- Notify
                    NotifyERRORBorder = { fg = c.vscSplitDark },
                    NotifyWARNBorder = { fg = c.vscSplitDark },
                    NotifyINFOBorder = { fg = c.vscSplitDark },
                    NotifyDEBUGBorder = { fg = c.vscSplitDark },
                    NotifyTRACEBorder = { fg = c.vscSplitDark },
                    NotifyERRORIcon = { fg = c.vscRed },
                    NotifyWARNIcon = { fg = c.vscDarkYellow },
                    NotifyINFOIcon = { fg = c.vscLightGreen },
                    NotifyDEBUGIcon = { fg = c.vscGray },
                    NotifyTRACEIcon = { fg = c.vscPink },
                    NotifyERRORTitle = { fg = c.vscRed },
                    NotifyWARNTitle = { fg = c.vscDarkYellow },
                    NotifyINFOTitle = { fg = c.vscLightGreen },
                    NotifyDEBUGTitle = { fg = c.vscGray },
                    NotifyTRACETitle = { fg = c.vscPink },
                },
            }
        end,
    },
}
