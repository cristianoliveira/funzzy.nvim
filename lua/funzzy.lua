local function open_panel(opts)
  if opts.split == "t" then
    vim.cmd("tabnew")
    return
  end

  if opts.split == "v" then
    vim.cmd("botright :vsplit")
    return
  end

  if opts.split == "s" then
    vim.cmd("botright :split")
    return
  end
end

local M = {}

-- Funzzy
-- Watches using the .watch.yaml file in the current directory.
--
-- @param opts.target: string (target to filter task from .watch.yaml)
-- @param opts.split: string (v, s, t) (vertical, horizontal, tab)
M.Funzzy = function(opts)
  open_panel(opts)

  if opts.target ~= "" then
    vim.cmd.terminal("funzzy --non-block --target \"" .. opts.target .. "\"")
    return
  end

  vim.cmd.terminal("funzzy --non-block")
end

-- FunzzyCmd
-- Watches the current directory and runs the given command on each change.
--
-- @param opts.command: string (command to run)
-- @param opts.split: string (v, s, t) (vertical, horizontal, tab)
M.FunzzyCmd = function(opts)
  open_panel(opts)

  -- get current file directory
  local current_pwd = vim.fn.expand('%:p:h')
  local find_in_dir = "find -d ".. current_pwd .." -depth 1"
  -- :h Bar
  vim.cmd.terminal(find_in_dir .." | funzzy " .. opts.command .. " --non-block")
end

-- FunzzyEdit
-- Opens the .watch.yaml file in edit mode. If the file does not exist, it will be created.
--
-- @param opts.split: string (v, s, t) (vertical, horizontal, tab)
M.FunzzyEdit = function(opts)
  if vim.fn.filereadable(".watch.yaml") == 0 then
    -- ask if user want to create .watch.yaml
    local create_answer = vim.fn.confirm("Funzzy: .watch.yaml was not found. Create for this directory?", "&Yes\n&No")
    if create_answer == 2 then
      return
    end

    vim.cmd("! funzzy init")
    while vim.fn.filereadable(".watch.yaml") == 0 do
      vim.cmd("sleep 1")
    end
  end

  open_panel(opts)
  vim.cmd.edit(".watch.yaml")
end

return M
