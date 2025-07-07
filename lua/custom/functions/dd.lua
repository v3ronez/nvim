local M = {}

function M.wrap_selection_with_fn(fn_name)
  -- get visual mode range
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if #lines == 0 then
    return
  end

  -- Join lines if it's multi-line

  local joined = table.concat(lines, ' '):gsub('\t', '')
  joined = joined:gsub('%s*;%s*$', '')

  -- Replace with wrapped function
  local new_line = fn_name .. '(' .. joined .. ');'
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, { new_line })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'php',
  callback = function()
    vim.api.nvim_create_user_command('WrapDD', function()
      require('custom.functions.dd').wrap_selection_with_fn 'dd'
    end, { range = true })

    vim.keymap.set('v', '<leader>pd', ':WrapDD<CR>', {
      desc = 'Wrap selection with dd',
      silent = true,
      buffer = true,
    })
  end,
})

return M
