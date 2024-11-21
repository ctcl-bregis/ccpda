function fileExists (path)
    local f = fs.open(path, "r");
    if f ~= nil then
        f.close();
        return true
    else
        return false
    end
end

function readFile (path)
    local f = fs.open(path, "r");
    content = f.readAll();
    f.close();
    return content
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
            -- Move i's kept value to j's position, if it's not already there.
            if (i ~= j) then
                t[j] = t[i];
                t[i] = nil;
            end
            j = j + 1; -- Increment position of where we'll place the next kept value.
        else
            t[i] = nil;
        end
    end

    return t;
end


-- Globals
ml, mh = term.getSize();