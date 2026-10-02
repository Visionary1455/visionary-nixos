-- 文件查找与文本搜索：telescope
-- 依赖 pkgs.fzf（已通过 programs.neovim.extraPackages 注入 PATH）
local M = {}

function M.setup()
  local telescope = require('telescope')
  local actions = require('telescope.actions')

  telescope.setup({
    defaults = {
      prompt_prefix = '> ',
      selection_caret = '  ',
      entry_prefix = '  ',
      initial_mode = 'insert',
      layout_strategy = 'horizontal',
      layout_config = {
        height = 0.85,
        width = 0.9,
        horizontal = { prompt_position = 'top' },
      },
      -- 用 Ctrl+j/k 上下移动候选，比 <Up>/<Down> 更顺手
      mappings = {
        i = {
          ['<C-j>'] = actions.move_selection_next,
          ['<C-k>'] = actions.move_selection_previous,
          ['<Down>'] = actions.move_selection_next,
          ['<Up>'] = actions.move_selection_previous,
          ['<CR>'] = actions.select_default,
          ['<C-y>'] = actions.toggle_selection,
          -- 选中的文件送入 quickfix 列表；smart_* 在未选中任何条目时送入全部条目
          ['<C-q>'] = actions.smart_send_to_qflist,
          -- 只在当前文件所在目录下查找，便于定位工程内的头文件与源码
          ['<C-d>'] = function(prompt_bufnr)
            local dir = vim.fn.expand('%:p:h')
            if dir == '' then
              return
            end
            actions.close(prompt_bufnr)
            require('telescope.builtin').find_files({ cwd = dir, prompt_title = '当前目录下查找文件' })
          end,
        },
      },
    },
  })

  -- 模糊匹配使用原生 fzf（需要 PATH 中存在 fzf）
  telescope.load_extension('fzf')

  local map = require('config.util').map
  -- telescope.builtin 是独立模块，必须显式 require；telescope.builtin 本身为 nil
  local builtin = require('telescope.builtin')

  -- 文件与缓冲区
  map('<leader>ff', builtin.find_files, { silent = true, desc = '查找：当前目录文件' })
  map('<leader>fb', builtin.buffers, { silent = true, desc = '查找：缓冲区列表' })
  map('<leader>fs', builtin.current_buffer_fuzzy_find, { silent = true, desc = '查找：当前文件内文本' })

  -- 文本搜索
  map('<leader>fg', builtin.live_grep, { silent = true, desc = '查找：工程内实时搜索' })
  map('<leader>fG', builtin.grep_string, { silent = true, desc = '查找：搜索光标下的单词' })

  -- 符号与其他
  map('<leader>fsx', builtin.lsp_document_symbols, { silent = true, desc = '查找：当前文件符号' })
  map('<leader>fsw', builtin.lsp_workspace_symbols, { silent = true, desc = '查找：工程内符号' })
  map('<leader>fh', builtin.help_tags, { silent = true, desc = '查找：帮助文档' })
  map('<leader>fk', builtin.keymaps, { silent = true, desc = '查找：快捷键映射' })
  map('<leader>fd', builtin.diagnostics, { silent = true, desc = '查找：当前文件诊断' })
end

return M
