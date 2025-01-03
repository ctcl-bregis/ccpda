os.loadAPI("ccpda/utils.lua")

config = textutils.unserializeJSON(utils.readFile("/ccpda/config.json"));

-- Offset values for drawing the map
mapx = math.floor((utils.ml - (7 * 3)) / 2) + 1
mapy = math.floor((utils.mh - (5 * 3)) / 2) + 2

curx = 1;
cury = 1;
curz = 1;

curxmax = config["base"]["size"]["x"];
curymax = config["base"]["size"]["z"];
curzmax = config["base"]["size"]["y"];

function chunkFromGps ()
    modem = peripheral.wrap(config["base"]["gps"]["side"]);
    x, z, y = gps.locate();

    x = config["base"]["gps"]["baseorigin"]["x"] - x;
    z = config["base"]["gps"]["baseorigin"]["y"] - z;
    y = config["base"]["gps"]["baseorigin"]["z"] - y;

    x = math.floor(x / 16) + 1;
    y = math.floor(y / 16) + 1;
    z = math.floor(z / 16) + 1;

    return x, y, z
end

term.setPaletteColor(colors.lightGray, 0x999999);
term.setPaletteColor(colors.gray, 0x888888);

while true do
    utils.clear();
    term.setCursorPos(1,1);
    term.write("Base Map");
    term.setCursorPos(utils.ml - 9, 1);
    term.write("End - Exit");
    term.setCursorPos(1,2);
    term.write(string.rep("-", utils.ml));
    
    c = true
    for x = 0,2 do
        for y = 0,2 do
            local mapcolor;
            if c then
                mapcolor = colors.gray;
            else
                mapcolor = colors.lightGray;
            end
            
            if (curx - 1 + x > 0) and (curx - 1 + x <= curxmax) and (cury - 1 + y > 0) and (cury - 1 + y <= curymax) then
                paintutils.drawFilledBox((x * 7) + mapx, (y * 5) + mapy, ((x + 1) * 7) + mapx - 1, ((y + 1) * 5) + mapy -1, mapcolor)
                term.setTextColor(colors.black);
                term.setCursorPos((x * 7) + mapx, (y * 5) + mapy);
                term.write(curx - 1 + x .. "-" .. cury - 1 + y);
            end 
            c = not c
        end
    end

    event, key, held = os.pullEvent("key");

    if key == keys["end"] then
        os.reboot();
    end

    if key == keys.right then
        if curx < curxmax then
            curx = curx + 1
        end
    elseif key == keys.left then
        if curx > 1 then
            curx = curx - 1
        end
    elseif key == keys.down then
        if cury < curymax then
            cury = cury + 1
        end
    elseif key == keys.up then
        if cury > 1 then
            cury = cury - 1
        end
    elseif key == keys.pageDown then
        
    elseif key == keys.pageUp then

    elseif key == keys.home then
        curx, cury, curz = chunkFromGps();
    end

    if key == keys.enter then
        utils.clear();
        term.setCursorPos(1,1);
        term.write("Chunk " .. curx .. "-" .. cury);
        term.setCursorPos(1,2);
        term.write(string.rep("-", utils.ml));

        chunkinfo = config["base"]["info"][curx .. "-" .. cury]
        if chunkinfo then
            term.setCursorPos(1,3);
            term.write("Description:");
            term.setCursorPos(1,4);
            term.write(chunkinfo["desc"]);
        else 
            term.setCursorPos(1,3);
            term.write("No information found");
        end

        event, key, held = os.pullEvent("key");
    end

end