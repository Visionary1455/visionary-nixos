-- 配置层共用的小工具
local M = {}

--- 绑定快捷键，mode 缺省为 normal 模式
---
--- 相比直接调用 vim.keymap.set(mode, lhs, rhs, opts)，这里把最常用的 mode 放到最后并
--- 提供默认值 'n'，让「左侧键位 → 右侧键位 → 选项」的三参调用成为默认写法。
---@param lhs string 左侧键位，如 '<leader>w'
---@param rhs string|function 右侧键位或函数
---@param opts? table vim.keymap.set 的选项，通常是 { desc = '...' }
---@param mode? string 模式，默认 'n'；其余取值同 vim.keymap.set
function M.map(lhs, rhs, opts, mode)
  vim.keymap.set(mode or 'n', lhs, rhs, opts)
end

return M