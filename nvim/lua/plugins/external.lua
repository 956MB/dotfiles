-- [[ markdown-preview.nvim ]]
-- No setup needed; build hook handled by PackChanged in pack.lua.
-- Commands: MarkdownPreviewToggle, MarkdownPreview, MarkdownPreviewStop

-- [[ overseer.nvim: task runner ]]
vim.o.shell = '/bin/bash'
vim.o.shellcmdflag = '-c'

require('overseer').setup {
    templates = { 'builtin' },
    task_list = {
        direction = 'bottom',
        bindings = {
            ['<CR>'] = 'RunAction',
            ['<C-e>'] = 'Edit',
            ['<C-j>'] = false,
            ['<C-k>'] = false,
        },
        default_detail = 1,
    },
}
