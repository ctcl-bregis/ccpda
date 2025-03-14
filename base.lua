-- CCPDA for ComputerCraft/CC: Tweaked
-- Purpose: Main script
-- Created: November 19, 2024
-- Modified: March 8, 2025
-- Designed for and tested with:
-- ComputerCraft 1.100.x 1.16.5; version found in Seaopolis (2021)

-- Though deprecated, "require" is not available in the ComputerCraft 1.75 from my testing
os.loadAPI("ccpda/utils.lua")

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

if not utils.fileExists("/ccpda/config.json") then
    print("config.json does not exist, creating default config");
    local f = fs.open("/ccpda/config.json", "w");
    -- TODO: Have a separate file for storing data and instead have config.json read-only
    -- Reminder: y is "up/down" in Minecraft
    -- Default is a 512x512x512
    local defaultconfig = [[{
    "base": {
        "size": {
            "x": 32,
            "y": 16,
            "z": 32
        },
        "gps": {
            "enabled": true,
            "side": "back",
            "baseorigin": {
                "x": 512,
                "y": 0,
                "z": 512
            }
        }
    }
}
]];
    f.write(defaultconfig);
    f.close();
    -- Exit the script so the user can edit the config
    print("config.json can now be edited");
    shell.exit();
else
    print("config.json found, starting");
    config = textutils.unserializeJSON(utils.readFile("/ccpda/config.json"));
end

if not fs.exists("/ccpda/data/") then
    fs.makeDir("/ccpda/data/");
end

-- Program loop
term.clear();

while true do
    for index, value in pairs(menuButtons) do
        if index == menuSelectedItem then
            paintutils.drawFilledBox(1,(index - 1) * 3 + 1,utils.ml,index * 3,colors.white);
            term.setTextColor(colors.black);
            term.setCursorPos(2, (index - 1) * 3 + 2)
            term.write(value["title"])
        else
            paintutils.drawFilledBox(1,(index - 1) * 3 + 1,utils.ml,index * 3,colors.black);
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
        shell.run("/ccpda/app/" .. mode);
        return
    end
end



