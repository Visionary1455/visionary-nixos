-- Neovim 配置入口
--
-- 插件本体由 flake 提供（module/hm/program/neovim.nix 里的 pkgs.vimPlugins），
-- 本目录只负责插件的行为配置，不包含任何安装逻辑。
--
-- 加载顺序有依赖关系：
--   options/keys 先建立基础环境 → treesitter 提供语法 → lsp/complete 依赖 LSP →
--   telescope/dap 绑定各自的键位 → ui 负责主题与状态栏

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')
require('config.keys')

-- 插件模块统一提供 setup()，必须显式调用：require 只加载模块定义，不会执行 setup
require('plugins.treesitter').setup()
require('plugins.lsp').setup()
require('plugins.format').setup()
require('plugins.complete').setup()
require('plugins.telescope').setup()
require('plugins.dap').setup()
require('plugins.ui').setup()
