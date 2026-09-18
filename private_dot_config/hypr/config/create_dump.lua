local f = io.open("/tmp/hl_dump.txt", "w")
for k, v in pairs(hl) do
  f:write(tostring(k) .. " = " .. tostring(v) .. "\n")
end
f:close()
