require ".base.utils";

clear();
term.setCursorPos(1,1);
term.write("Base Map");
term.setCursorPos(ml - 9, 1);
term.write("End - Exit");
term.setCursorPos(1,2);
term.write(string.rep("-", ml));

curx = 1
cury = 1


while true do
    event, key, held = os.pullEvent("key");

    if key == keys["end"] then
        os.reboot();
    end

end