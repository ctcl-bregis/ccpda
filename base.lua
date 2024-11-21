-- Chunk Base Info Application for ComputerCraft/CC: Tweaked - CTCL 2024
-- Purpose: Main script
-- Created: November 19, 2024
-- Modified: November 19, 2024
-- Designed for ComputerCraft 1.100.x 1.16.5; version found in Seaopolis (2021)

require "utils"

menuButtons = {
    {
        title = "Map";
        mode = "map";
    };
    {
        title = "To-Do List";
        mode = "todo";
    };
}
menuSelectedItem = 1;

function writeDefaultConfig ()
    local f = fs.open("/base/config.json", "w");
    -- Reminder: y is "up/down" in Minecraft
    -- Default is a 512x512x512
    local defaultconfig = [[{
    "basesize": {
        "x": 16,
        "y": 8,
        "z": 16
    },
    "gps": {
        "enabled": true,
        "side": null
    }
}
]];
    f.write(defaultconfig);
    f.close();
end

if not fileExists("/base/config.json") then
    print("config.json does not exist, creating default config");
    writeDefaultConfig();
    -- Exit the script so the user can edit the config
    os.reboot();
else 
    print("config.json found, starting");
    config = textutils.unserializeJSON(readFile("/base/config.json"));
end

-- Program loop
term.clear();

while true do
    for index, value in pairs(menuButtons) do
        if index == menuSelectedItem then
            paintutils.drawFilledBox(1,(index - 1) * 3 + 1,ml,index * 3,colors.white);
            term.setTextColor(colors.black);
            term.setCursorPos(2, (index - 1) * 3 + 2)
            term.write(value["title"])
        else
            paintutils.drawFilledBox(1,(index - 1) * 3 + 1,ml,index * 3,colors.black);
            term.setTextColor(colors.white);
            term.setCursorPos(2, (index - 1) * 3 + 2)
            term.write(value["title"])
        end
    end

    local event, key, held = os.pullEvent("key");

    if key == keys.down and menuSelectedItem < 2 then
        menuSelectedItem = menuSelectedItem + 1;
    elseif key == keys.up and menuSelectedItem > 1 then
        menuSelectedItem = menuSelectedItem - 1;
    elseif key == keys.enter then
        mode = menuButtons[menuSelectedItem]["mode"];
        shell.run("base/app/" .. mode);
        return
    end
end



