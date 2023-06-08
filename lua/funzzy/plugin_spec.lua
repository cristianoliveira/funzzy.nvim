local funzzy = require("lua/funzzy/plugin")

local TRUE = 0
local FALSE = 1

local FAKE_CHANNEL_ID = 1234

local vim = {
  g = {
    funzzy_bin = "/usr/bin/funzzy"
  },

  cmd = function() end,

  b = { terminal_job_id = FAKE_CHANNEL_ID },

  fn = {
    stdpath = function() return "/.cache/nvim" end,
    isdirectory = function() return TRUE end,
    getcwd = function() return "/workdir" end,
    sha256 = function() return "workdir_as_hash" end,
    filereadable = function() return TRUE end,
    confirm = function() return TRUE end,
    edit = function() end,
    delete = function() return TRUE end,
    mkdir = function() return TRUE end,
    writefile = function() return TRUE end,
  },
}

describe("funzzy plugin", function()
  describe("Commands", function()
    describe(":Funnzy", function()
      it("spins up the watcher with the received 'target'", function()
        spy.on(vim, "cmd")

        funzzy(vim).Funzzy({ target = "tests", split = ""})

        assert
          .spy(vim.cmd)
          .was_called_with("terminal /usr/bin/funzzy --non-block --target tests")
      end)

      it("spins up the watcher without target by default", function()
        spy.on(vim, "cmd")

        funzzy(vim).Funzzy({ target = "", split = ""})

        assert
          .spy(vim.cmd)
          .was_called_with("terminal /usr/bin/funzzy --non-block")
      end)
    end)

    describe(":FunzzyCmd", function()
      it("watches the current workdir and runs the given command", function()
        vim.fn.expand = function() return "/current_dir" end
        spy.on(vim, "cmd")

        funzzy(vim).FunzzyCmd({ command = "echo 'test'", split = ""})

        assert
          .spy(vim.cmd)
          .was_called_with(
            "terminal" ..
            " find -d /current_dir -depth 1 |" ..
            " /usr/bin/funzzy echo 'test' --non-block"
          )
      end)
    end)

    describe(":FunzzyEdit", function()
      it("asks to create the config file in the working dir "..
            "if not present but DO NOT create if answer is NO", function()

        vim.fn.filereadable = function() return FALSE end
        vim.fn.confirm = function() return FALSE end

        spy.on(vim, "cmd")

        funzzy(vim).FunzzyEdit({ split = "" })

        assert
          .spy(vim.cmd)
          .not_was_called("! funzzy init")
      end)

      it("asks to create the config file in the working dir "..
          "if not present, runs funzzy init waiting to be" ..
          "created before opening it", function()

        local times = 0
        vim.fn.filereadable = function()
          times = times + 1
          if times > 2 then return FALSE end
          return TRUE
        end

        vim.fn.confirm = function() return 1 end

        spy.on(vim, "cmd")

        funzzy(vim).FunzzyEdit({ split = "" })

        assert
          .spy(vim.cmd)
          .was_called_with("! funzzy init")
        assert
          .spy(vim.cmd)
          .was_called_with("edit .watch.yaml")
      end)
    end)
  end)

  describe(":FunzzyClose", function()
    it("does not close anything if no channel is open in the cache", function()
      vim.fn.filereadable = function() return 0 end
      vim.notify = spy.new(function() end)

      funzzy(vim).FunzzyClose()

      assert
        .spy(vim.notify)
        .was_called_with("Funzzy: Nothing to close")
    end)

    it("closes all channels within the channels storage", function()
      vim.fn.filereadable = function() return 1 end
      vim.fn.readfile = spy.new(function()
        return { "1234", "5678" }
      end)
      vim.fn.chanclose = spy.new(function() end)

      funzzy(vim).FunzzyClose()

      assert
        .spy(vim.fn.readfile)
        .was_called_with("/.cache/nvim/funzzy/workdir_as_hash")
      assert
        .spy(vim.fn.chanclose)
        .was_called_with(1234)
      assert
        .spy(vim.fn.chanclose)
        .was_called_with(5678)
    end)
  end)

  describe("split opts", function()
    it("opens the watcher in a new tab when split is 't'", function()
      spy.on(vim, "cmd")

      funzzy(vim).Funzzy({ target = "", split = "t"})

      assert.spy(vim.cmd).was_called_with("tabnew")
    end)

    it("opens the watcher in a new vertical split when split is 'v'", function()
      spy.on(vim, "cmd")

      funzzy(vim).Funzzy({ target = "", split = "v"})

      assert.spy(vim.cmd).was_called_with("botright :vsplit")
    end)

    it("opens the watcher in a new horizontal split when split is 's'", function()
      spy.on(vim, "cmd")

      funzzy(vim).Funzzy({ target = "", split = "s"})

      assert.spy(vim.cmd).was_called_with("botright :split")
    end)

    it("opens the watcher in current buffer when split is empty", function()
      spy.on(vim, "cmd")

      funzzy(vim).Funzzy({ target = "", split = ""})

      assert.spy(vim.cmd).not_was_called_with(
        "tabnew", "botright :split", "botright :vsplit"
      )
    end)
  end)

  describe("on init", function()
    it("deletes the cache when cache for current workdir is present", function()
      vim.fn.filereadable = function() return TRUE end
      spy.on(vim.fn, "delete")

      funzzy(vim).init()

      assert
        .spy(vim.fn.delete)
        .was_called_with("/.cache/nvim/funzzy/workdir_as_hash")
    end)

    it("creates cache directory when not present", function()
      spy.on(vim.fn, "mkdir")

      funzzy(vim).init()

      assert
        .spy(vim.fn.mkdir)
        .was_called_with("/.cache/nvim/funzzy", "p")
    end)
  end)
end)
