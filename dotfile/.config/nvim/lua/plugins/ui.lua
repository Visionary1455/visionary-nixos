-- 界面：主题、状态栏、缓冲区栏、文件树、命令面板、Git 改动标记、快捷键提示、诊断列表
local M = {}

function M.setup()
  -- 主题（Catppuccin Mocha，背景透明以融入 niri 下的终端）
  require('catppuccin').setup({ flavour = 'mocha', transparent_background = true })
  vim.cmd.colorscheme('catppuccin')

  -- 状态栏
  require('lualine').setup({
    options = {
      -- catppuccin 的 lualine 主题按 flavour 分别导出，没有名为 catppuccin 的主题，
      -- 写成 'catppuccin' 会静默回退到 auto，状态栏就丢失配色
      theme = 'catppuccin-mocha',
      globalstatus = true, -- 所有窗口共用一行状态栏
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff' },
      lualine_c = { 'filename' },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      -- clangd 进度与 LSP 诊断计数
      lualine_y = { 'progress' },
      lualine_z = { 'diagnostics' },
    },
  })

  -- 缓冲区栏
  require('bufferline').setup({
    options = {
      mode = 'buffers', -- 显示所有缓冲区而非仅当前可见窗口
      show_close_icon = false,
      show_bufferline_selectors = false,
      separator_style = 'thin', -- 经典竖线分隔，斜线分隔会挤占过多横向空间
      always_show_bufferline = false,
    },
  })

  -- 文件树
  require('neo-tree').setup({
    close_if_last_window = true, -- 关掉文件树窗口后回到编辑区
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      follow_current_file = { enabled = true }, -- 打开文件时自动展开所在目录
      use_libuv_file_watcher = true,
    },
    window = {
      width = 32,
      mappings = {
        ['<space>'] = 'none', -- 阻止 <space> 误触发节点打开
      },
    },
  })

  -- 命令面板与通知
  require('noice').setup({
    presets = {
      bottom_search = false, -- 用 telescope 取代底部搜索面板
    },
  })

  -- 诊断/错误列表
  require('trouble').setup()

  -- Git 改动标记
  require('gitsigns').setup({
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  })

  -- 快捷键提示
  require('which-key').setup({ preset = 'modern' })

  local map = require('config.util').map

  -- 文件树
  map('<leader>e', '<Cmd>Neotree toggle<CR>', { desc = '文件树：切换显示' })
  map('<leader>ef', '<Cmd>Neotree find_file<CR>', { desc = '文件树：定位当前文件' })

  -- 诊断列表
  map('<leader>xx', '<Cmd>TroubleToggle<CR>', { desc = '诊断：切换列表' })
  map('<leader>xX', '<Cmd>TroubleToggle document_diagnostics<CR>', { desc = '诊断：当前文件' })
  map('<leader>xq', '<Cmd>TroubleToggle quickfix<CR>', { desc = '诊断：quickfix 列表' })
  map('<leader>xt', '<Cmd>TroubleToggle telescope<CR>', { desc = '诊断：telescope 列表' })

  -- Git 改动块之间跳转（由 gitsigns 提供）
  map(']c', function()
    require('gitsigns').nav_hunk('next')
  end, { desc = 'Git：下一个改动块' })
  map('[c', function()
    require('gitsigns').nav_hunk('prev')
  end, { desc = 'Git：上一个改动块' })
end

return M
