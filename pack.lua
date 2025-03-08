-- CCPDA for ComputerCraft/CC: Tweaked
-- Purpose: Creates a "self-extracting" Lua file
-- Created: January 3, 2025
-- Modified: January 3, 2025
-- Designed for and tested with:
-- ComputerCraft 1.100.x 1.16.5; version found in Seaopolis (2021)
-- ComputerCraft 1.75 1.7.10

-- CURRENTLY UNFINISHED

filelist = {
    "ccpda/app/map.lua";
    "ccpda/app/todo.lua";
    "ccpda/base.lua";
    "ccpda/utils.lua";
}

contents = [[
data = {

]]

for i,file in pairs(filelist) do
    local f = fs.open(file, "r")
    if f then
        local data = f.readAll()
        data = data:gsub("\"", "\\\"")
        data = data:gsub("\r\n", "\\n")
        data = data:gsub("\n", "\\n")
        local line = "{\"" .. file .. "\", \"" .. data .. "\"};\r\n"
        contents = contents .. line
    end
end

contents = contents .. "\r\n};"


pack = [[-- Automatically generated file

]];
pack = pack .. contents;
-- TODO: actually writing the files
pack = pack .. [[

for i, file in pairs(data) do
    
end 
]]

local f = fs.open("out.lua", "w")
f.write(pack)
f.close()
