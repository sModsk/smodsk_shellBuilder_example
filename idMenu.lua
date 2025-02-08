-- In this example we fetch all shell ids that are tagged as public 
-- and draw simple menu that allows us to view shells


local selectedIndex = 1
local menuOpen = false
local itemColor = vec4(255, 255, 255, 255)
local itemSelectedColor = vec4(100, 255, 100, 255)

local function drawMenu(ids)
    local startX, startY = 0.8, 0.1
    local lineHeight = 0.05
    
    for i, id in ipairs(ids) do
        local color = itemColor
        
        if i == selectedIndex then
            color = itemSelectedColor
        end
        
        SetTextColour(color.x, color.y, color.z, color.w)
        SetTextFont(0)
        SetTextScale(0.5, 0.5)
        SetTextCentre(true)
        SetTextDropShadow()
        SetTextEntry("STRING")
        AddTextComponentString(id)
        DrawText(startX, startY + (i - 1) * lineHeight)
    end
end
local function handleMenuInput(ids)
    if IsControlJustPressed(0, 172) then 
        selectedIndex = math.max(1, selectedIndex - 1)
    elseif IsControlJustPressed(0, 173) then
        selectedIndex = math.min(#ids, selectedIndex + 1)
    elseif IsControlJustPressed(0, 191) then

        exports["smodsk_shellBuilder"]:DespawnShell()
        MyHouse = {}
        InHouse = false

        SpawnShell(ids[selectedIndex])
    elseif IsControlJustReleased(0, 177) then
        menuOpen = false
    end
end

RegisterCommand("getPublicIds", function (source, args)
    if menuOpen then return end
    menuOpen = true 

    local ids = exports["smodsk_shellBuilder"]:GetPublicIds()

    CreateThread(function()
        while menuOpen do
           Wait(0) 
            if menuOpen then
                drawMenu(ids)
                handleMenuInput(ids)
            end
        end
    end)
end, false)
