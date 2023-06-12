--
-- cmd_builder: Build a command from a list of arguments
--
return function(...)
  local cmd = select(1, ...)

  for i = 2, select("#", ...) do
    local arg = select(i, ...)
    if arg ~= nil and arg ~= "" then
      cmd = cmd .. " " .. arg
    end
  end

  return cmd
end
