package.path = package.path .. ';lua/?.lua'
local funzzy = require("funzzy.plugin")

local TRUE = 0
local FALSE = 1

local FAKE_CHANNEL_ID = 1234

local vim = {
  g = {
    funzzy_bin = "/usr/bin/funzzy"
  },

  b = { terminal_job_id = FAKE_CHANNEL_ID },

  cmd = spy.new(function() end),
  notify = spy.new(function() end),
  fn = {},
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
          .was_not_called("! /usr/bin/funzzy init")
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
          .was_called_with("! /usr/bin/funzzy init")
        assert
          .spy(vim.cmd)
          .was_called_with("edit .watch.yaml")
      end)

      it("times out if the config file is not created after 5 attempts", function()
        vim.fn.filereadable = spy.new(function() return 0 end)
        vim.notify = spy.new(function() end)

        funzzy(vim).FunzzyEdit({ split = "" })

        assert
          .spy(vim.fn.filereadable)
          .was_called(5 + 1)
        assert
          .spy(vim.notify)
          .was_called_with("Funzzy: .watch.yaml was not created")
        assert
          .spy(vim.cmd)
          .was_not_called("edit .watch.yaml")
      end)
    end)
  end)

  describe(":FunzzyClose", function()
    it("does not close anything if no channel is open in the cache", function()
      vim.notify = spy.new(function() end)

      funzzy(vim).FunzzyClose()

      assert
        .spy(vim.notify)
        .was_called_with("Funzzy: Nothing to close")
    end)

    it("closes all channels within the open channels", function()
      vim.fn.filereadable = function() return 1 end
      vim.fn.chanclose = spy.new(function() end)

      local instance = funzzy(vim)

      vim.b.terminal_job_id = 1234
      instance.Funzzy({ target = "", split = ""})
      vim.b.terminal_job_id = 3456
      instance.Funzzy({ target = "", split = ""})

      instance.FunzzyClose()

      assert
        .spy(vim.fn.chanclose)
        .was_called_with(1234)
      assert
        .spy(vim.fn.chanclose)
        .was_called_with(3456)
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

      assert.spy(vim.cmd).was_not_called_with(
        "tabnew", "botright :split", "botright :vsplit"
      )
    end)
  end)
end)
