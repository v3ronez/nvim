-- =============================================================
-- Second Brain / Digital Brain
-- Notes path: /Users/veronez/notes
-- =============================================================

local M = {}

-- Path to your notes
local DB = '/Users/veronez/notes'

-- =============================================================
-- Path & suffix setup (allows `gf` to jump between .md links)
-- =============================================================
vim.opt.path:append(DB .. '/**')
vim.opt.suffixesadd:append '.md'

-- =============================================================
-- Search engine using fff.nvim
-- Requires: dmtrKovalenko/fff.nvim
-- =============================================================

-- Search notes content (or tag under cursor) with fff live_grep
local function db_search(query)
  local ok, fff = pcall(require, 'fff')
  if not ok then
    print '[brain.nvim] fff.nvim is required for search'
    return
  end

  -- If query starts with '#', append word boundary for accurate tag search
  local pattern = query
  if query and query:sub(1, 1) == '#' then
    pattern = query .. '\\b'
  end

  -- Temporarily change cwd so fff scopes to notes folder
  local prev_cwd = vim.fn.getcwd()
  vim.fn.chdir(DB)
  fff.live_grep { query = pattern or '', cwd = DB }
  vim.fn.chdir(prev_cwd)
end

-- Full interactive live grep across notes
local function db_live_search()
  local ok, fff = pcall(require, 'fff')
  if not ok then
    print '[brain.nvim] fff.nvim is required for search'
    return
  end

  local prev_cwd = vim.fn.getcwd()
  vim.fn.chdir(DB)
  fff.live_grep { cwd = DB }
  vim.fn.chdir(prev_cwd)
end

-- =============================================================
-- Keymaps
-- =============================================================
local function setup_keymaps()
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  -- Open index note
  map('n', '<leader>db', function()
    vim.cmd('edit ' .. DB .. '/index.md')
  end, vim.tbl_extend('force', opts, { desc = 'Brain: open index' }))

  -- Open TODO note
  map('n', '<leader>do', function()
    vim.cmd('edit ' .. DB .. '/TODO.md')
  end, vim.tbl_extend('force', opts, { desc = 'Brain: open TODO' }))

  -- Open today's daily note (creates file if it doesn't exist)
  -- Expected folder structure: notes/5_Daily/YYYY-MM-DD.md
  map('n', '<leader>dD', function()
    local date = os.date '%Y-%m-%d'
    local daily_path = DB .. '/5_Daily/' .. date .. '.md'
    vim.fn.mkdir(DB .. '/5_Daily', 'p') -- ensure folder exists
    vim.cmd('edit ' .. daily_path)
    -- Seed the file with a heading if it's brand new
    if vim.fn.getfsize(daily_path) <= 0 then
      local lines = { '# ' .. date, '', '' }
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    end
  end, vim.tbl_extend('force', opts, { desc = "Brain: open today's daily" }))

  -- Search tag under cursor (like pressing F in the original)
  map('n', 'F', function()
    local word = vim.fn.expand '<cWORD>'
    db_search(word)
  end, vim.tbl_extend('force', opts, { desc = 'Brain: search tag under cursor' }))

  -- Full text search (interactive)
  map('n', '<leader>fS', db_live_search, vim.tbl_extend('force', opts, { desc = 'Brain: full text search' }))

  -- Fuzzy-find note files by name
  map('n', '<leader>fN', function()
    local ok, fff = pcall(require, 'fff')
    if not ok then
      return
    end
    local prev_cwd = vim.fn.getcwd()
    vim.fn.chdir(DB)
    fff.find_files { cwd = DB }
    vim.fn.chdir(prev_cwd)
  end, vim.tbl_extend('force', opts, { desc = 'Brain: find note by name' }))
end

-- =============================================================
-- Git auto-commit on exit (only when inside the notes folder)
-- =============================================================
local function setup_git_autocommit()
  vim.api.nvim_create_autocmd('VimLeavePre', {
    desc = 'Brain: auto git commit & push on exit',
    callback = function()
      -- Only run if cwd is inside the notes folder
      local cwd = vim.fn.getcwd()
      if not cwd:find(DB, 1, true) then
        return
      end

      local datetime = os.date '%Y-%m-%d %H:%M:%S'

      -- Synchronous calls so Neovim doesn't exit before git finishes
      vim.fn.system('cd ' .. DB .. ' && git add -A')

      local diff = vim.fn.system('cd ' .. DB .. ' && git diff --cached --quiet; echo $?')
      local has_changes = vim.trim(diff) ~= '0'

      if has_changes then
        vim.fn.system(string.format("cd %s && git commit -m 'brain: %s'", DB, datetime))
      end

      vim.fn.system('cd ' .. DB .. ' && git push origin main')

      if vim.v.shell_error == 0 then
        print('🧠 Brain synced: ' .. datetime)
      else
        print '🧠 Brain sync failed (git error)'
      end
    end,
  })
end

-- =============================================================
-- Setup entry point — call require("custom.functions.brain").setup()
-- =============================================================
function M.setup()
  setup_keymaps()
  setup_git_autocommit()
  print('🧠 Brain loaded → ' .. DB)
end

return M
