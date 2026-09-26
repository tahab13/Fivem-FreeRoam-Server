local playersInSafeZone = {}

local function IsPlayerInSafeZone(playerId)
    local ped = GetPlayerPed(playerId)

    if not ped or ped == 0 then
        return false
    end

    local coords = GetEntityCoords(ped)

    for _, zone in ipairs(Config.SafeZones) do
        local zonePos = vector3(zone.x, zone.y, zone.z)

        if #(coords - zonePos) <= zone.radius then
            return true
        end
    end

    return false
end

RegisterNetEvent('safezone:setState', function(state)
    local src = source

    if state then
        playersInSafeZone[src] = true
    else
        playersInSafeZone[src] = nil
    end
end)

RegisterNetEvent('safezone:checkPlayer', function()
    local src = source

    local inSafeZone = IsPlayerInSafeZone(src)
    local wasInSafeZone = playersInSafeZone[src] == true

    if inSafeZone and not wasInSafeZone then
        playersInSafeZone[src] = true

        TriggerClientEvent('safezone:forceEnter', src)

    elseif not inSafeZone and wasInSafeZone then
        playersInSafeZone[src] = nil

        TriggerClientEvent('safezone:forceExit', src)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source

    playersInSafeZone[src] = nil
end)

CreateThread(function()
    while true do
        Wait(1000)

        for _, playerId in ipairs(GetPlayers()) do
            TriggerClientEvent('safezone:checkPlayer', playerId)
        end
    end
end)