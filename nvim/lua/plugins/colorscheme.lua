return {
    { -- syntax highlighting for kitty.conf
        'fladson/vim-kitty',
    },

    { -- Color scheme
        -- 'Mofiqul/vscode.nvim',
        dir = '~/dotfiles/nvim/lua/plugins/custom/vscode.nvim',
        lazy = false,
        config = function()
            local bg1, bg2, scrollBg = 'NONE', '#141414', '#262626'
            local bufferBg, bufferBgSel = '#0D0D0D', '#181818'
            local vscode = require 'vscode'
            local c = require('vscode.colors').get_colors()

            local color_overrides = {
                lualineBg = bg1,
                lualineBg2 = bg1,
                vscLeftMid = bg1,
                vscDiffRedDark = '#2B0D0D',
                vscDiffRedLight = '#400B0B',
                vscDiffRedLightLight = '#910101',
                vscDiffGreenDark = '#202317',
                vscDiffGreenLight = '#2B311C',
                vscGitAdded = '#0F3A0F',
                vscGitModified = '#0F1E3A',
                vscGitDeleted = '#3A0F0F',
                vscGitRenamed = '#0F3A0F',
                vscGitUntracked = '#0F3A0F',
                vscGitIgnored = '#3A3A3A',
                vscGitStageModified = '#0F1E3A',
                vscGitStageDeleted = '#3A0F0F',
                vscGitConflicting = '#3A0F0F',
            }

            local modes = { 'normal', 'visual', 'inactive', 'replace', 'insert', 'terminal', 'command' }
            local lualine_overrides = {}
            for _, mode in ipairs(modes) do
                lualine_overrides[mode] = {
                    b = { fg = c.vscPink, bg = bg1 },
                    c = { bg = bg1 },
                }
            end

            local black_fg = { 'visual', 'insert', 'replace', 'terminal', 'command' }
            for _, mode in ipairs(black_fg) do
                lualine_overrides[mode] = {
                    a = { fg = c.vscBack },
                }
            end

            local group_overrides = {
                -- Basic UI elements
                DevIcon = { fg = '#ff0000', bg = 'NONE' },
                VertSplit = { fg = c.vscSplitDark, bg = bg1 },
                WinBar = { bg = bg1, fg = bg1 },
                WinBarNC = { bg = bg1, fg = bg1 },
                Normal = { fg = c.vscFront, bg = bg1 },
                NormalNC = { fg = c.vscFront, bg = bg1 },
                NormalFloat = { bg = bg1 },
                -- SignColumn = { bg = bg1 },
                Delimiter = { fg = '#444444', bg = bg1 },
                DiffAdd = { fg = c.vscFront, bg = c.vscGitAdded },
                DiffChange = { fg = c.vscFront, bg = c.vscGitModified },
                DiffDelete = { fg = c.vscFront, bg = c.vscGitDeleted },
                DiffText = { fg = c.vscFront, bg = c.vscGitRenamed },

                GitSignsAddLn = { fg = 'NONE', bg = c.vscGitAdded },
                GitSignsDeleteLn = { fg = 'NONE', bg = c.vscGitDeleted },
                GitWordAdd = { bg = c.vscGitAdded },
                GitWordDelete = { bg = c.vscGitDeleted },

                -- Noice cmdline
                NoiceCmdlinePrompt = { fg = c.vscFront, bg = c.vscPink },
                NoiceCmdlineNormal = { fg = 'NONE', bg = bg2 },
                NoiceCmdlinePopupBorder = { fg = bg2, bg = bg2 },
                NoiceCmdlinePopupTitle = { fg = c.vscFront, bg = c.vscPink },

                -- Telescope
                TelescopeNormal = { fg = 'NONE', bg = bg2 },
                TelescopeBorder = { fg = bg2, bg = bg2 },
                TelescopePromptBorder = { fg = c.vscLeftMid, bg = c.vscLeftMid },
                TelescopePromptNormal = { fg = c.vscFront, bg = c.vscLeftMid },
                TelescopePromptCounter = { fg = c.vscPopupFront, bg = c.vscLeftMid },
                TelescopePromptPrefix = { fg = c.vscPink, bg = c.vscLeftMid },
                TelescopePromptTitle = { fg = c.vscBack, bg = c.vscMediumBlue, bold = true },
                TelescopeResultsBorder = { fg = bg2, bg = bg2 },
                TelescopePreviewBorder = { fg = bg2, bg = bg2 },
                TelescopeResultsTitle = { fg = bg2, bg = bg2, bold = true },
                TelescopePreviewTitle = { fg = c.vscBack, bg = c.vscBlueGreen, bold = true },
                TelescopeSelectionCaret = { fg = c.vscPopupFront, bg = 'NONE' },

                -- quicker.nvim (quickfix)
                QuickFixHeaderHard = { fg = '#444444', bg = bg1 },
                QuickFixHeaderSoft = { fg = '#444444', bg = bg1 },
                QuickFixFilename = { bg = bg1, fg = c.vscBlue },

                -- Line numbers and whitespace
                LineNr = { fg = '#444444', bg = bg1 },
                CursorLineNr = { fg = '#AFAFAF', bg = c.vscCursorDarkDark },
                SignColumn = { fg = 'NONE', bg = 'NONE' },
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
                ScrollbarHandle = { bg = scrollBg, fg = 'NONE' },
                ScrollbarCursorHandle = { bg = scrollBg, fg = 'NONE' },
                ScrollbarWarn = { bg = 'NONE', fg = '#FFDF88' },
                ScrollbarError = { bg = 'NONE', fg = '#FFBDB7' },
                ScrollbarHint = { bg = 'NONE', fg = '#97DDFF' },
                ScrollbarWarnHandle = { bg = scrollBg, fg = '#FFDF88' },
                ScrollbarErrorHandle = { bg = scrollBg, fg = '#FFBDB7' },
                ScrollbarHintHandle = { bg = scrollBg, fg = '#97DDFF' },
                ScrollbarGitAdd = { fg = '#2DA042', bg = bg1 },
                ScrollbarGitChange = { fg = c.vscBlue, bg = bg1 },
                ScrollbarGitDelete = { fg = c.vscRed, bg = bg1 },
                ScrollbarGitAddHandle = { fg = scrollBg, bg = scrollBg },
                ScrollbarGitChangeHandle = { fg = scrollBg, bg = scrollBg },
                ScrollbarGitDeleteHandle = { fg = scrollBg, bg = scrollBg },

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
                NvimTreeNormal = { fg = c.vscFront, bg = bg1 },
                NvimTreeCursorLine = { fg = 'NONE', bg = scrollBg },
                NvimTreeVertSplit = { fg = c.vscSplitDark, bg = bg1 },
                NvimTreeEndOfBuffer = { fg = bg1 },
                NvimTreeOpenedFolderName = { fg = 'NONE', bg = bg1 },
                NvimTreeGitRenamed = { fg = c.vscGitRenamed, bg = 'NONE' },
                NvimTreeGitIgnored = { fg = c.vscGitIgnored, bg = 'NONE' },
                NvimTreeGitDeleted = { fg = c.vscGitDeleted, bg = 'NONE' },
                NvimTreeGitStaged = { fg = c.vscGitStageModified, bg = 'NONE' },
                NvimTreeGitMerge = { fg = c.vscGitUntracked, bg = 'NONE' },
                NvimTreeGitDirty = { fg = c.vscGitModified, bg = 'NONE' },
                NvimTreeGitNew = { fg = c.vscGitAdded, bg = 'NONE' },

                -- BufferLine
                --
                BufferLineFill = { fg = 'NONE', bg = bufferBg },
                -- BufferLineDiagnostics = { fg = '#3357FF', bg = '#FF3357' },
                -- BufferLineTab = { fg = '#57FF33', bg = '#5733FF' },
                -- BufferLineTabSelected = { fg = '#33FFA7', bg = '#A733FF' },
                -- BufferLineTabClose = { fg = '#FFA733', bg = '#33FFA7' },
                BufferLineDuplicate = { fg = '#555555', bg = bufferBg },
                BufferLineDuplicateSelected = { fg = c.vscSplitLight, bg = bufferBgSel },
                -- BufferLineDuplicateVisible = { fg = '#7F33FF', bg = '#FF7F33' },
                BufferLineBackground = { fg = '#555555', bg = bufferBg },
                -- BufferLineCloseButton = { fg = '#FF337F', bg = '#33FF7F' },
                -- BufferLineCloseButtonSelected = { fg = '#7FFF33', bg = '#337FFF' },
                -- BufferLineCloseButtonVisible = { fg = '#337FFF', bg = '#7FFF33' },
                -- BufferLineBufferVisible = { fg = '#FF7F33', bg = '#33FF7F' },
                -- BufferLineSeperator = { fg = '#33A7FF', bg = '#FFA733' },
                BufferLineSeperatorVisible = { fg = '#A733FF', bg = '#33A7FF' },
                BufferLineGroupSeperator = { fg = '#FF33A7', bg = '#A7FF33' },
                BufferLineSeparator = { fg = bufferBg, bg = bufferBg },
                BufferLineBufferSelected = { fg = c.vscFront, bg = bufferBgSel },
                -- BufferLineDiagnostic = { fg = '#A7FF33', bg = '#FF33A7' },
                -- BufferLinePick = { fg = '#FF5733', bg = '#33FF57' },
                -- BufferLinePickSelected = { fg = '#3357FF', bg = '#FF3357' },
                -- BufferLineSeparatorSelected = { fg = '#57FF33', bg = '#5733FF' },
                BufferLineIndicatorSelected = { fg = '#777777', bg = bufferBgSel },
                -- BufferLineDevIconLuaSelected = { fg = '#FFA733', bg = '#33FFA7' },
                -- BufferLineDevIconDefaultInactive = { fg = '#A7FF33', bg = '#FF33A7' },
                -- BufferLineError = { fg = '#7F33FF', bg = '#FF7F33' },
                -- BufferLineErrorDiagnostic = { fg = '#33FF7F', bg = '#7F33FF' },
                -- BufferLineErrorVisible = { fg = '#FF337F', bg = '#33FF7F' },
                -- BufferLineErrorDiagnosticVisible = { fg = '#7FFF33', bg = '#337FFF' },
                -- BufferLineErrorSelected = { fg = '#337FFF', bg = '#7FFF33' },
                -- BufferLineErrorDiagnosticSelected = { fg = '#FF7F33', bg = '#33FF7F' },
                -- BufferLineWarning = { fg = '#33A7FF', bg = '#FFA733' },
                -- BufferLineWarningVisible = { fg = '#A733FF', bg = '#33A7FF' },
                -- BufferLineWarningDiagnosticVisible = { fg = '#FF33A7', bg = '#A7FF33' },
                -- BufferLineWarningDiagnostic = { fg = '#33FFA7', bg = '#A733FF' },
                -- BufferLineWarningSelected = { fg = '#FFA733', bg = '#33FFA7' },
                -- BufferLineWarningDiagnosticSelected = { fg = '#A7FF33', bg = '#FF33A7' },
                -- BufferLineInfo = { fg = '#FF5733', bg = '#33FF57' },
                -- BufferLineInfoVisible = { fg = '#3357FF', bg = '#FF3357' },
                -- BufferLineInfoDiagnosticVisible = { fg = '#57FF33', bg = '#5733FF' },
                -- BufferLineInfoDiagnostic = { fg = '#33FFA7', bg = '#A733FF' },
                -- BufferLineInfoSelected = { fg = '#FFA733', bg = '#33FFA7' },
                -- BufferLineInfoDiagnosticSelected = { fg = '#A7FF33', bg = '#FF33A7' },
                -- BufferLineModifiedVisible = { fg = '#7F33FF', bg = '#FF7F33' },
                -- BufferLineModified = { fg = '#33FF7F', bg = '#7F33FF' },
                -- BufferLineModifiedSelected = { fg = '#FF337F', bg = '#33FF7F' },

                -- BufferLineFill = { bg = bufferBg },
                -- BufferLineIndicatorSelected = { fg = '#606060', bg = bufferBg },
                -- BufferLineSeparator = { fg = '#181818', bg = bufferBg },
                -- BufferLineBufferSelected = { fg = 'NONE', bg = '#ffff00' },
                -- BufferLineSeparatorVisible = { fg = '#00ff00', bg = 'NONE' },
                -- BufferLineBackground = { fg = '#0000ff', bg = 'NONE' },
                -- BufferLineBackgroundSelected = { fg = '#00ffff', bg = '#0d9f99' },
                -- BufferLineTab = { fg = '#00ffff', bg = '#00ff00' },
                -- BufferLineTabSelected = { fg = '#00ffff', bg = '#00ff00' },
                -- BufferLineDevIconVim = { fg = '#019833', bg = bufferBg },
                -- BufferLineDevIconVimSelected = { fg = '#019833', bg = bufferBgSel },
                -- BufferLineDevIconLua = { fg = '#51A0CF', bg = bufferBg },
                -- BufferLineDevIconLuaSelected = { fg = '#51A0CF', bg = bufferBgSel },
                -- BufferLineDevIconPython = { fg = '#FFD43B', bg = bufferBg },
                -- BufferLineDevIconPythonSelected = { fg = '#FFD43B', bg = bufferBgSel },
                -- BufferLineDevIconRust = { fg = '#DEA584', bg = bufferBg },
                -- BufferLineDevIconRustSelected = { fg = '#DEA584', bg = bufferBgSel },
                -- BufferLineDevIconJavaScript = { fg = '#F7DF1E', bg = bufferBg },
                -- BufferLineDevIconJavaScriptSelected = { fg = '#F7DF1E', bg = bufferBgSel },
                -- BufferLineDevIconTypeScript = { fg = '#007ACC', bg = bufferBg },
                -- BufferLineDevIconTypeScriptSelected = { fg = '#007ACC', bg = bufferBgSel },
                -- BufferLineDevIconHtml = { fg = '#E34F26', bg = bufferBg },
                -- BufferLineDevIconHtmlSelected = { fg = '#E34F26', bg = bufferBgSel },
                -- BufferLineDevIconCss = { fg = '#1572B6', bg = bufferBg },
                -- BufferLineDevIconCssSelected = { fg = '#1572B6', bg = bufferBgSel },
                -- BufferLineDevIconJson = { fg = '#FAC31D', bg = bufferBg },
                -- BufferLineDevIconJsonSelected = { fg = '#FAC31D', bg = bufferBgSel },
                -- BufferLineDevIconMarkdown = { fg = '#519ABA', bg = bufferBg },
                -- BufferLineDevIconMarkdownSelected = { fg = '#519ABA', bg = bufferBgSel },
                -- BufferLineDevIconC = { fg = '#599EDD', bg = bufferBg },
                -- BufferLineDevIconCSelected = { fg = '#599EDD', bg = bufferBgSel },
                -- BufferLineDevIconCpp = { fg = '#00599C', bg = bufferBg },
                -- BufferLineDevIconCppSelected = { fg = '#00599C', bg = bufferBgSel },
                -- BufferLineDevIconJava = { fg = '#007396', bg = bufferBg },
                -- BufferLineDevIconJavaSelected = { fg = '#007396', bg = bufferBgSel },
                -- BufferLineDevIconGo = { fg = '#00ADD8', bg = bufferBg },
                -- BufferLineDevIconGoSelected = { fg = '#00ADD8', bg = bufferBgSel },
                -- BufferLineDevIconBash = { fg = '#4EAA25', bg = bufferBg },
                -- BufferLineDevIconBashSelected = { fg = '#4EAA25', bg = bufferBgSel },
                -- BufferLineDevIconDefault = { fg = '#ff0000', bg = c.vscHover },
                -- BufferLineDevIconDefaultSelected = { fg = '#00ff00', bg = c.vscHover },

                -- Diffview
                DiffviewNormal = { fg = c.vscFront, bg = bg1 },
                DiffviewCursorLine = { bg = c.vscCursorDarkDark },
                DiffviewVertSplit = { fg = c.vscSplitDark, bg = bg1 },
                DiffviewStatusLine = { fg = c.vscFront, bg = c.vscLeftDark },
                DiffviewStatusLineNC = { fg = c.vscFrontDark, bg = c.vscLeftDark },
                DiffviewFilePanelTitle = { fg = c.vscLightBlue, bg = 'NONE', bold = true },
                DiffviewFilePanelCounter = { fg = c.vscBlue, bg = 'NONE', bold = true },
                DiffviewFilePanelFileName = { fg = c.vscFront, bg = 'NONE' },
                DiffviewFilePanelPath = { fg = c.vscFrontDark, bg = 'NONE' },
                DiffviewFilePanelInsertions = { fg = c.vscGitAdded, bg = 'NONE' },
                DiffviewFilePanelDeletions = { fg = c.vscGitDeleted, bg = 'NONE' },
                DiffviewStatusAdded = { fg = c.vscGitAdded, bg = bg1 },
                DiffviewStatusUntracked = { fg = c.vscGitAdded, bg = bg1 },
                DiffviewStatusModified = { fg = c.vscGitModified, bg = bg1 },
                DiffviewStatusRenamed = { fg = c.vscGitRenamed, bg = bg1 },
                DiffviewStatusDeleted = { fg = c.vscGitDeleted, bg = bg1 },

                -- oil.nvim
                OilDir = { fg = c.vscBlue, bg = 'NONE' },
                OilDirIcon = { fg = c.vscYellowOrange, bg = 'NONE' },
                OilSocket = { fg = c.vscPink, bg = 'NONE' },
                OilLink = { fg = c.vscPink, bg = 'NONE' },
                OilLinkTarget = { fg = '#666666', bg = 'NONE' },
                OilFile = { fg = c.vscFront, bg = 'NONE' },
                OilCreate = { fg = c.vscGreen, bg = 'NONE' },
                OilDelete = { fg = c.vscRed, bg = 'NONE' },
                OilMove = { fg = c.vscYellow, bg = 'NONE' },
                OilCopy = { fg = c.vscGreen, bg = 'NONE' },
                OilChange = { fg = c.vscYellow, bg = 'NONE' },
                OilRestore = { fg = c.vscYellowOrange, bg = 'NONE' },
                OilPurge = { fg = c.vscRed, bg = 'NONE' },
                OilTrash = { fg = c.vscRed, bg = 'NONE' },
                OilTrashSourcePath = { fg = '#666666', bg = 'NONE' },

                -- OilGitStatus highlights
                OilGitStatusIndexUnmodified = { fg = c.vscFront, bg = 'NONE' },
                OilGitStatusWorkingTreeUnmodified = { fg = c.vscFront, bg = 'NONE' },
                OilGitStatusIndexIgnored = { fg = c.vscGitIgnored, bg = 'NONE' },
                OilGitStatusWorkingTreeIgnored = { fg = c.vscGitIgnored, bg = 'NONE' },
                OilGitStatusIndexUntracked = { fg = c.vscGitUntracked, bg = 'NONE' },
                OilGitStatusWorkingTreeUntracked = { fg = c.vscGitUntracked, bg = 'NONE' },
                OilGitStatusIndexAdded = { fg = '#2DA042', bg = 'NONE' },
                OilGitStatusWorkingTreeAdded = { fg = '#2DA042', bg = 'NONE' },
                OilGitStatusIndexCopied = { fg = '#2DA042', bg = 'NONE' },
                OilGitStatusWorkingTreeCopied = { fg = '#2DA042', bg = 'NONE' },
                OilGitStatusIndexDeleted = { fg = c.vscRed, bg = 'NONE' },
                OilGitStatusWorkingTreeDeleted = { fg = c.vscRed, bg = 'NONE' },
                OilGitStatusIndexModified = { fg = c.vscBlue, bg = 'NONE' },
                OilGitStatusWorkingTreeModified = { fg = c.vscBlue, bg = 'NONE' },
                OilGitStatusIndexRenamed = { fg = c.vscGitRenamed, bg = 'NONE' },
                OilGitStatusWorkingTreeRenamed = { fg = c.vscGitRenamed, bg = 'NONE' },
                OilGitStatusIndexTypeChanged = { fg = c.vscBlue, bg = 'NONE' },
                OilGitStatusWorkingTreeTypeChanged = { fg = c.vscBlue, bg = 'NONE' },
                OilGitStatusIndexUnmerged = { fg = c.vscGitConflicting, bg = 'NONE' },
                OilGitStatusWorkingTreeUnmerged = { fg = c.vscGitConflicting, bg = 'NONE' },

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

                -- nvim-ufo fold virtual text
                UfoSuffixHighlight = { fg = c.vscFront, bg = c.vscFoldBackground },
            }

            vscode.setup {
                disable_nvimtree_bg = true,
                color_overrides = color_overrides,
                group_overrides = group_overrides,
                lualine_overrides = lualine_overrides,
            }
        end,
    },
}
