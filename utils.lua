-- CCPDA for ComputerCraft/CC: Tweaked
-- Purpose: Main script
-- Created: November 19, 2024
-- Modified: March 8, 2025

-- Globals
ml, mh = term.getSize();

function fileExists (path)
    if not path then
        return false
    end

    local f = fs.open(path, "r");
    if f ~= nil then
        f.close();
        return true
    else
        return false
    end
end

function readFile (path)
    if not fileExists(path) then
        return nil
    end

    local f = fs.open(path, "r");
    content = f.readAll();
    return content;
end

function readFileToLines (path)
    if not fileExists(path) then
        error("File does not exist");
    end
    local f = io.open(path, "r");
    local lines = {};
    local i = 0;
    for line in f:lines() do
        i = i + 1;
        lines[i] = line
    end
    f:close();
    return lines
end

function clear ()
    term.setBackgroundColor(colors.black);
    term.setTextColor(colors.white);
    term.clear();
end

function arrayRemove (t)
    local j, n = 1, #t;

    for i=1,n do
        if (t[i] == 'deleteme') then
            if (i ~= j) then
                t[j] = t[i];
                t[i] = nil;
            end
            j = j + 1;
        else
            t[i] = nil;
        end
    end

    return t;
end

function splittokens(s)
    local res = {}
    for w in s:gmatch("%S+") do
        res[#res+1] = w
    end
    return res
end

function wrapString(str)
    linewidth = ml

    local spaceleft = linewidth
    local res = {}
    local line = {}

    for _, word in ipairs(splittokens(str)) do
        if #word + 1 > spaceleft then
            table.insert(res, table.concat(line, ' '))
            line = {word}
            spaceleft = linewidth - #word
        else
            table.insert(line, word)
            spaceleft = spaceleft - (#word + 1)
        end
    end

    table.insert(res, table.concat(line, ' '))
    return res
end

-- term.write() does not seem to do newlines with "/n" so use the wrapString() function
function writeWrapped(str)
    local wrapped = wrapString(str);
    for i, line in ipairs(wrapped) do
        term.write(line);
        local curx, cury = term.getCursorPos();
        term.setCursorPos(1, cury + 1); 
    end
end

-- Similar function but it takes in a table of strings
function writeMultiline(strs)
    for i, line in ipairs(strs) do
        term.write(line);
        local curx, cury = term.getCursorPos();
        term.setCursorPos(1, cury + 1);
    end
end

-- Reinventing the wheel here
function wrappedRead (replaceChar, history, completeFn, default)
    local input = "";

    while true do
        local event, key, held = os.pullEvent("key");

        if key == keys["backspace"] then
            if #input > 0 then
                input = input:sub(1, #input - 1);
                term.setCursorPos(term.getCursorPos()[1] - 1, term.getCursorPos()[2]);
            end
        elseif key == keys["return"] then
            return input;
        end

    end

end

local charset = {}  do -- [0-9a-zA-Z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

function randomString(length)
    if not length or length <= 0 then return '' end
    math.randomseed(os.clock() ^ 5)
    return randomString(length - 1) .. charset[math.random(1, #charset)]
end