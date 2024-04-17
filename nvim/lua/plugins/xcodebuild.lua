local progress_handle

return {
    'wojciech-kulik/xcodebuild.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
        'MunifTanjim/nui.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require('xcodebuild').setup {
            show_build_progress_bar = true,
            logs = {
                auto_open_on_success_tests = false,
                auto_open_on_failed_tests = false,
                auto_open_on_success_build = false,
                auto_open_on_failed_build = false,
                auto_focus = false,
                auto_close_on_app_launch = true,
                only_summary = true,
                notify = function(message, severity)
                    local fidget = require 'fidget'
                    if progress_handle then
                        progress_handle.message = message
                        if not message:find 'Loading' then
                            progress_handle:finish()
                            progress_handle = nil
                            if vim.trim(message) ~= '' then
                                fidget.notify(message, severity)
                            end
                        end
                    else
                        fidget.notify(message, severity)
                    end
                end,
                notify_progress = function(message)
                    local progress = require 'fidget.progress'

                    if progress_handle then
                        progress_handle.title = ''
                        progress_handle.message = message
                    else
                        progress_handle = progress.handle.create {
                            message = message,
                            lsp_client = { name = 'xcodebuild.nvim' },
                        }
                    end
                end,
            },
            code_coverage = {
                enabled = true,
            },
        }
    end,
}
