MyHouse = {}
InHouse = false

-- @key string (door or garage)
-- @position vector4 or nil
local function doorPositionChanged(key, position)
    MyHouse.exits[key] = position
end

local function teleport(position)
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player)
    local entity = (vehicle ~= 0) and vehicle or player
    SetEntityCoords(entity, position.x, position.y, position.z, false, false, false, false)
    SetEntityHeading(entity, position.w)
    if vehicle ~= 0 then 
        TaskWarpPedIntoVehicle(player, vehicle, -1) 
    end
end

-- Both can't be nil 
-- @doorPos vector4 or nil
-- @garagePos vector4 or nil
local function enterHouse(doorPos, garagePos)
    if InHouse then return end 
    
    MyHouse.exits = { door = doorPos, garage = garagePos }
    local player, vehicle = PlayerPedId(), GetVehiclePedIsIn(PlayerPedId())
    local exitSpawn = GetEntityCoords(player)
    local exitHeading = GetEntityHeading(player) - 180

    if not garagePos and vehicle ~= 0 then
        -- We can't teleport inside since there is no garagePos defined
        print("^1 We can't teleport inside since there is no garagePos defined")
        exports["smodsk_shellBuilder"]:DespawnShell()
        return 
    else
        teleport((vehicle ~= 0) and garagePos or (doorPos ~= nil) and doorPos or garagePos)
    end

    InHouse = true

    CreateThread(function()
        while InHouse do
            player = PlayerPedId()
            local coords = GetEntityCoords(player)
            for _, pos in pairs(MyHouse.exits) do
                if pos then
                    local distance = #(coords - vec3(pos.x, pos.y, pos.z))
                    if distance < 20.0 then
                        DrawMarker(1, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, 1, 1, .3, 255, 0, 0, 150, false, false, 2, false)
                        if distance < 2.0 and IsControlJustReleased(0, 38) then
                            teleport(vec4(exitSpawn.x, exitSpawn.y, exitSpawn.z, exitHeading))
                            exports["smodsk_shellBuilder"]:DespawnShell()
                            MyHouse = {}
                            InHouse = false
                            return
                        end
                    end
                end
            end
            Wait(1)
        end
    end)
end

function SpawnShell(id)
    if InHouse then return end
    local success, doorPos, garagePos = exports["smodsk_shellBuilder"]:SpawnShell(
    {
        id = id,
        position = vec3(-1314, -3164, 13),
        doorPositionChanged = function(door, position)
            doorPositionChanged(door, position)
        end,
        canOpenMenu = function()
            return true
        end,
        canTogglePublic = function()
            return true
        end,
        canBuild = function()
            return true
        end,
        canPaint = function()
            return true
        end
    })
    if success then
        enterHouse(doorPos, garagePos)
    end
end

RegisterCommand("enterShell", function (source, args)
    local id = args[1]
    SpawnShell(id)
end, false)






