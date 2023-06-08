local cmd_builder = require("lua.funzzy.cmd_builder")

return function(vim)
  --
  -- Funzzy configuration variables
  --
  -- funzzy_bin: string (path to funzzy binary)
  --
  local funzzy_bin = vim.g.funzzy_bin or vim.fn.exepath("funzzy")

  local FUNZZY_CONFIG_FILE = ".watch.yaml"

  local function open_buffer(opts)
    if opts.split == "t" then
      return vim.cmd("tabnew")
    end

    if opts.split == "v" then
      return vim.cmd("botright :vsplit")
    end

    if opts.split == "s" then
      return vim.cmd("botright :split")
    end
  end

  local function channels_storage()
    local current_pwd = vim.fn.getcwd()
    local dir = vim.fn.stdpath('cache') .. '/funzzy'

    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end

    local cacheid = vim.fn.sha256(current_pwd)
    return dir .. "/" .. cacheid
  end

  local function open_funzzy_terminal(cmd)
    vim.cmd("terminal " .. cmd)
    local channel_id = vim.b.terminal_job_id

    vim.fn.writefile({channel_id}, channels_storage(), "a")
  end

  local M = {}

  -- Funzzy
  -- Watches using the .watch.yaml file in the current directory.
  --
  -- @param opts.target: string (target to filter task from .watch.yaml)
  -- @param opts.split: string (v, s, t) (vertical, horizontal, tab)
  M.Funzzy = function(opts)
    open_buffer(opts)

    if opts.target ~= "" then
      return open_funzzy_terminal(
        cmd_builder(funzzy_bin, "--non-block", "--target", opts.target)
      )
    end

    open_funzzy_terminal(cmd_builder(funzzy_bin, "--non-block"))
  end

  -- FunzzyCmd
  -- Watches the current directory and runs the given command on each change.
  --
  -- @param opts.command: string (command to run)
  -- @param opts.split: string (v, s, t) (vertical, horizontal, tab)
  M.FunzzyCmd = function(opts)
    open_buffer(opts)

    -- get current file directory
    local current_pwd = vim.fn.expand('%:p:h')
    local find_in_dir = cmd_builder("find", "-d", current_pwd, "-depth 1")
    local funzzy_cmd = cmd_builder(funzzy_bin, opts.command, "--non-block")

    open_funzzy_terminal(cmd_builder(find_in_dir,"|", funzzy_cmd))
  end

  -- FunzzyEdit
  -- Opens the .watch.yaml file in edit mode. If the file does not exist, it will be created.
  --
  -- @param opts.split: string (v, s, t) (vertical, horizontal, tab)
  M.FunzzyEdit = function(opts)
    if vim.fn.filereadable(".watch.yaml") == 0 then
      -- ask if user want to create .watch.yaml
      local create_answer = vim.fn.confirm("Funzzy: .watch.yaml was not found. Create for this directory?", "&Yes\n&No")
      if create_answer ~= 1 then
        return
      end


      vim.cmd(cmd_builder("!", "funzzy", "init"))
      local attempts = 5
      while vim.fn.filereadable(".watch.yaml") == 0 or attempts > 0 do
        vim.cmd("sleep 1")
        attempts = attempts - 1
      end
    end

    open_buffer(opts)
    vim.cmd("edit " .. FUNZZY_CONFIG_FILE)
  end

  -- FunzzyClose
  -- Closes all funzzy channels for the current working directory.
  --
  -- *Important*
  -- You don't need to call this command manually before exiting Vim,
  -- Vim takes care of closing all channels automatically.
  --
  -- This is useful if you have multiple funzzy instances running in different terminals
  -- and want to close them all at once.
  M.FunzzyClose = function()
    local session_channels = channels_storage()
    if vim.fn.filereadable(session_channels) == 0 then
      vim.notify("Funzzy: Nothing to close")
      return
    end

    local pids = vim.fn.readfile(session_channels)
    for _, pid in ipairs(pids) do
      pcall(vim.fn.chanclose, tonumber(pid))
    end

    vim.fn.delete(session_channels)
    vim.notify("Funzzy: Closed all channels")
  end

  M.init = function()
    local channels = channels_storage()
    if vim.fn.filereadable(channels) == 0 then
      vim.fn.delete(channels)
    end
  end

  return M
end
