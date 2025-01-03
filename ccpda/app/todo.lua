os.loadAPI("ccpda/utils.lua")

config = textutils.unserializeJSON(utils.readFile("/ccpda/config.json"));

if not utils.fileExists("/ccpda/todo.txt") then
    f = fs.open("/ccpda/todo.txt", "w");
    f.write("");
    f.close();
end

selectedItem = 1;

items = utils.readFileToLines("/ccpda/todo.txt");

while true do
    utils.clear();
    term.setCursorPos(1,1);
    term.write("To-Do");
    term.setCursorPos(utils.ml - 9, 1);
    term.write("End - Exit");
    term.setCursorPos(1,2);
    term.write(string.rep("-", utils.ml));

    term.setCursorPos(1,3);

    if #items < 1 then
        term.setCursorPos(1,3);
        print("No items");
    end
    
    for index, text in pairs(items) do
        if index == selectedItem then
            term.setBackgroundColor(colors.white);
            term.setTextColor(colors.black);
            print("- " .. text);
        else 
            term.setBackgroundColor(colors.black);
            term.setTextColor(colors.white);
            print("- " .. text);
        end
    end

    event, key, held = os.pullEvent("key");

    -- bracket notation is required here since end is a keyword
    if key == keys["end"] then
        os.reboot();
    end

    if key == keys.down and selectedItem < #items then
        selectedItem = selectedItem + 1;
    elseif key == keys.up and selectedItem > 1 then
        selectedItem = selectedItem - 1;
    elseif key == keys.delete then
        table.remove(items, selectedItem);
    elseif key == keys.enter then
        utils.clear();
        term.setCursorPos(1,1);
        term.write("To-Do - Edit Item")
        term.setCursorPos(1,2);
        term.write(string.rep("-", utils.ml));
        term.setCursorPos(1,3);
        term.write("- ");
        local entry = read(nil, nil, nil, items[selectedItem]);
        items[selectedItem] = entry;
    elseif key == keys.space then
        utils.clear();
        term.setCursorPos(1,1);
        term.write("To-Do - New Item")
        term.setCursorPos(1,2);
        term.write(string.rep("-", utils.ml));
        term.setCursorPos(1,3);
        term.write("- ");
        local entry = read();
        items[#items + 1] = entry;
    end
    f = io.open("/ccpda/todo.txt", "w");
    for index, item in pairs(items) do
        f:write(item, "\n");
    end
    f:close();
end