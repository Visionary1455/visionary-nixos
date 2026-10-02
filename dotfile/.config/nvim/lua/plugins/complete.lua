-- 补全：blink.cmp
--
-- 补全源只用 LSP 与路径两类，避免引入多余的噪音源；图标由 blink-nerdfont-nvim 提供
-- （本机已安装 Nerd Fonts，见 module/system/nixos/fonts.nix）。
--
-- keymap 的动作名受 blink.cmp 校验：必须是其内部命令表里的名字，写错会在 setup 时
-- 直接报 "expected commands must be one of: ..."，可用 :help blink-cmp-config-keymap 核对。
local M = {}

function M.setup()
  local cmp = require('blink.cmp')

  cmp.setup({
    keymap = {
      -- default 预设已含 <C-space> / <C-e> / <C-y> / <Up> / <Down> / <C-p> / <C-n> / <Tab>，
      -- 下面的条目是在预设之上的增量覆盖
      preset = 'default',
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      -- 接受当前高亮项
      ['<C-e>'] = { 'select_and_accept', 'fallback' },
      -- 展示/隐藏文档窗口
      ['<C-S-Tab>'] = { 'show_documentation', 'hide_documentation', 'fallback' },
      -- 直接插入当前高亮项，不弹菜单
      ['g<Tab>'] = { 'show_and_insert', 'fallback_to_mappings' },
      -- 在方向键之外用 Tab / S-Tab 浏览菜单
      ['<Tab>'] = { 'select_next', 'fallback_to_mappings' },
      ['<S-Tab>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<Down>'] = { 'select_next', 'fallback_to_mappings' },
      ['<Up>'] = { 'select_prev', 'fallback_to_mappings' },
      ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
      ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      -- 在文档窗口内向下滚动
      ['<C-u>'] = { 'scroll_documentation_down', 'fallback' },
    },
    completion = {
      documentation = { auto_show = true, max_width = 80, max_height = 20 },
    },
    sources = {
      default = { 'lsp', 'path' },
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
  })
end

return M