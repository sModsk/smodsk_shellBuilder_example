RegisterCommand("createShell", function (source, args)
    local id = args[1]
    local x = args[2] and tonumber(args[2])
    local y = args[3] and tonumber(args[3])
    local size
    if x and y then size = {x, y} end
    local success = exports["smodsk_shellBuilder"]:CreateNewShell(id, size)
    if success then
        print("Created shell", id)
    else
        print("Failed to create shell", id)
    end
end, false)

RegisterCommand("deleteShell", function (source, args)
    local id = args[1]
    exports["smodsk_shellBuilder"]:DeleteShell(id)
end, false)