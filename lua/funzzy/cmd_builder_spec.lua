local cmd_builder = require("lua.funzzy.cmd_builder")

describe("cmd_builder", function()
  it("returns command and arguments as string", function()
    assert.are.equal(cmd_builder("ls", "-la"), "ls -la")
    assert.are.equal(
      cmd_builder("/bin/funzzy", "", "--non-block", "--target", "tests"),
      "/bin/funzzy --non-block --target tests"
    )
  end)
end)
