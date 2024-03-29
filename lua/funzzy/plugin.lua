local cmd_builder = require('funzzy.cmd_builder')
return function(vim)
  --
  -- Funzzy configuration variables
  --
  -- funzzy_bin: string (path to funzzy binary)
  --
  local funzzy_bin         = vim.g.funzzy_bin or vim.fn.exepath("funzzy")

  local has_funzzy_deps    = function()
    if vim.fn.filereadable(funzzy_bin) == 0 then
      return false
    end

    return true
  end

  vim.g.funzzy_has_deps    = vim.g.funzzy_has_deps or has_funzzy_deps

  local has_correct_setup  = function()
    if not vim.g.funzzy_has_deps() then
      vim.notify("Funzzy: funzzy cli not found run `cargo install funzzy`")
      return false
    end

    return true
  end

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

  -- Stores all open channels
  local channels = {}

  -- Funzzy Module
  local M = {}

  local function open_funzzy_terminal(cmd)
    vim.cmd("terminal " .. cmd)
    table.insert(channels, vim.b.terminal_job_id)
  end


  -- Funzzy
  -- Watches using the .watch.yaml file in the current directory.
  --
  -- @param opts.target: string (target to filter task from .watch.yaml)
  -- @param opts.split: string (v, s, t) (vertical, horizontal, tab)
  M.Funzzy = function(opts)
    if not has_correct_setup() then
      return
    end

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
    if not has_correct_setup() then
      return
    end

    open_buffer(opts)

    local workdir = vim.fn.expand('%:p:h')
    local find_in_dir = cmd_builder("find", "-d", workdir, "-depth 1")
    local run_arbitrary_cmd = cmd_builder(
      funzzy_bin,
      opts.command,
      "--non-block"
    )

    open_funzzy_terminal(cmd_builder(find_in_dir, "|", run_arbitrary_cmd))
  end

  -- FunzzyEdit
  -- Opens the .watch.yaml file in edit mode. If the file does not exist, it will be created.
  --
  -- @param opts.split: string (v, s, t) (vertical, horizontal, tab)
  M.FunzzyEdit = function(opts)
    if not has_correct_setup() then
      return
    end

    local file_not_found = false
    if vim.fn.filereadable(".watch.yaml") == 0 then
      -- ask if user want to create .watch.yaml
      local create_answer = vim.fn.confirm(
        "Funzzy: .watch.yaml was not found. " ..
        "Create for this directory?", "&Yes\n&No"
      )

      if create_answer ~= 1 then
        return
      end


      vim.cmd(cmd_builder("!", funzzy_bin, "init"))
      local attempts = 5
      while vim.fn.filereadable(".watch.yaml") == 0 do
        vim.cmd("sleep 1")
        attempts = attempts - 1

        if attempts <= 0 then
          file_not_found = true
          break
        end
      end
    end

    if file_not_found then
      return vim.notify("Funzzy: .watch.yaml was not created")
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
    if next(channels) == nil then
      return vim.notify("Funzzy: Nothing to close")
    end

    for _, pid in pairs(channels) do
      pcall(vim.fn.chanclose, tonumber(pid))
    end

    vim.notify("Funzzy: Closed all channels")
  end

  return M
end
