-- 通用键位
local map = require('config.util').map
local opts = { silent = true, noremap = true }

-- 窗口跳转：不带修饰键的 hjkl 在 normal 模式下移动光标，Ctrl 版用于切窗口
map('<C-h>', '<C-w>h', opts)
map('<C-j>', '<C-w>j', opts)
map('<C-k>', '<C-w>k', opts)
map('<C-l>', '<C-w>l', opts)

-- 窗口操作
map('<leader>w', '<C-w>', opts) -- <leader>w 为窗口命令前缀（<C-w> 后接 h/j/k/l 等）
map('<leader>o', '<C-w>o', opts) -- 新开窗口
map('<leader>v', '<C-w>v', opts) -- 垂直分屏
map('<leader>s', '<C-w>s', opts) -- 水平分屏
map('<leader>q', '<C-w>q', opts) -- 关闭窗口
map('<leader>=', '=', opts) -- 窗口等分

-- 标签页
map('<leader>tn', '<Cmd>tabnew<CR>', opts)
map('<leader>tc', '<Cmd>tabclose<CR>', opts)
map('<leader>tp', '<Cmd>tabprevious<CR>', opts)
map('<leader>tnx', '<Cmd>tabnext<CR>', { silent = true, desc = '下一个标签页' })
map('<leader>tm', '<Cmd>tabmove<CR>', opts)

-- 缓冲区
map('<leader>bd', '<Cmd>bdelete<CR>', opts)
for i = 1, 9 do
  map('<leader>' .. i, function()
    vim.cmd('buffer ' .. i)
  end, { desc = '第 ' .. i .. ' 个缓冲区' })
end

-- 复制到系统剪贴板并立即提示
map('<leader>y', '"+y', opts)
map('<leader>p', '"+p', opts)

-- 全选并可视模式退出
map('<leader>gh', '<Cmd>nohlsearch<CR>', opts)

-- 在窗口间上下移动（不改变当前窗口尺寸）
map('<S-j>', '<Cmd>wincmd j<CR>', { silent = true, desc = '移动到下方窗口' })
map('<S-k>', '<Cmd>wincmd k<CR>', { silent = true, desc = '移动到上方窗口' })
