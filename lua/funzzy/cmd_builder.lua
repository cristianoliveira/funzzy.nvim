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
