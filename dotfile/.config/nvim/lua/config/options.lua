-- 基础编辑器选项
local opt = vim.opt

-- 界面
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes' -- 永远显示 sign 列，避免显示/隐藏时行号跳动
opt.cursorline = true
opt.termguicolors = true
opt.mouse = 'a'
opt.splitbelow = true
opt.splitright = true
opt.winborder = 'rounded'
opt.scrolloff = 4
opt.sidescrolloff = 8

-- 搜索
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- 剪切板：Wayland 下经 wl-clipboard 与系统剪贴板互通
opt.clipboard = 'unnamedplus'

-- 缩进：C/C++ 的具体宽度最终由 clang-format / treesitter 决定，此处仅为兜底
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

-- 补全：不在弹出菜单时自动选中第一项，回车才会插入
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.pumheight = 12

-- 性能与持久化
opt.updatetime = 250
opt.timeoutlen = 400
opt.swapfile = false
opt.shadafile = 'NONE'
opt.undofile = true

-- C/C++ 常用：显示制表符与行尾空白，定位风格问题
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- 不自动读取被改动过的文件，避免隐藏的 swap 冲突弹窗
opt.hidden = true

-- 大文件与语法折叠的默认行为
opt.foldlevel = 99
opt.foldmethod = 'manual'

-- 关闭不必要的启动动画
opt.shortmess:append('I')

-- 光标在 insert 模式下也更平滑地跟随
opt.lazyredraw = false

-- 文件类型图标：本机已装 Nerd Fonts，显式开启 NerdFont 变体，
-- 必须在 nvim-web-devicons 加载前设置（options.lua 是 init.lua 里最先执行的部分）
vim.g.webdevicons = { default = true, NerdFont = true }
