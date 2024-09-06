local progress_handle

return {
    {
        'wojciech-kulik/xcodebuild.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'MunifTanjim/nui.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        cmd = {
            'XcodebuildPicker',
            'XcodebuildBuild',
            'XcodebuildRun',
            'XcodebuildTest',
            'XcodebuildClean',
            'XcodebuildSetup',
        },
        event = {
            'BufReadPost *.swift',
            'BufReadPost *.m',
            'BufReadPost *.h',
            'BufReadPost *.cpp',
            'BufReadPost *.c',
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
    },

    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'wojciech-kulik/xcodebuild.nvim',
        },
        config = function()
            local xcodebuild = require 'xcodebuild.integrations.dap'
            local codelldbPath = os.getenv 'HOME' .. '/dotfiles/nvim/codelldb-aarch64-darwin/extension/adapter/codelldb'

            xcodebuild.setup(codelldbPath)

            local function map(lhs, rhs, opts)
                opts = opts or {}
                opts.silent = opts.silent ~= false
                vim.keymap.set('n', lhs, rhs, opts)
            end

            map('<leader>dd', xcodebuild.build_and_debug, { desc = 'Build & Debug' })
            map('<leader>dr', xcodebuild.debug_without_build, { desc = 'Debug Without Building' })
            map('<leader>dt', xcodebuild.debug_tests, { desc = 'Debug Tests' })
            map('<leader>dT', xcodebuild.debug_class_tests, { desc = 'Debug Class Tests' })
            map('<leader>b', xcodebuild.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
            map('<leader>B', xcodebuild.toggle_message_breakpoint, { desc = 'Toggle Message Breakpoint' })
            map('<leader>dx', xcodebuild.terminate_session, { desc = 'Terminate Debugger' })

            -- dap/dapui auto open/close
            local dap, dapui = require 'dap', require 'dapui'
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },

    { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' } },
}
