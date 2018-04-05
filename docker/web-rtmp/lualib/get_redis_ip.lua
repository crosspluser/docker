for line in io.lines("/etc/hosts") do
    local res = string.match(line, "(.+)%s+redis%s");
    if (res) then
        do return res end;
    end
end
