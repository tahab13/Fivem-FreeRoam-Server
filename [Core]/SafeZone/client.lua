local playerInSafeZone = false
local currentSafeZone = nil
local blips = {}

local function IsPlayerInSafeZone()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    for _, zone in ipairs(Config.SafeZones) do
        local zonePos = vector3(zone.x, zone.y, zone.z)

        if #(coords - zonePos) <= zone.radius then
            return true, zone
        end
    end

    return false, nil
end

local function DeleteVehicle(vehicle)
    if not DoesEntityExist(vehicle) then
        return
    end

    if not IsEntityAVehicle(vehicle) then
        return
    end

    NetworkRequestControlOfEntity(vehicle)

    local timeout = GetGameTimer() + 2000

    while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() < timeout do
        NetworkRequestControlOfEntity(vehicle)
        Wait(0)
    end

    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteEntity(vehicle)

    if DoesEntityExist(vehicle) then
        SetEntityAsNoLongerNeeded(vehicle)
        DeleteEntity(vehicle)
    end
end

local function DeleteVehiclesInsideSafeZones()
    local vehicles = GetGamePool('CVehicle')

    for _, vehicle in ipairs(vehicles) do
        if DoesEntityExist(vehicle) then
            local vehicleCoords = GetEntityCoords(vehicle)

            for _, zone in ipairs(Config.SafeZones) do
                local zonePos = vector3(zone.x, zone.y, zone.z)

                if #(vehicleCoords - zonePos) <= zone.radius then
                    DeleteVehicle(vehicle)
                    break
                end
            end
        end
    end
end

local function EnterSafeZone(zone)
    if playerInSafeZone then
        return
    end

    playerInSafeZone = true
    currentSafeZone = zone

    local playerId = PlayerId()
    local ped = PlayerPedId()

    SetEntityInvincible(ped, true)
    SetPlayerInvincible(playerId, true)

    SetEntityCanBeDamaged(ped, false)

    TriggerServerEvent('safezone:setState', true)
end

local function ExitSafeZone()
    if not playerInSafeZone then
        return
    end

    playerInSafeZone = false
    currentSafeZone = nil

    local playerId = PlayerId()
    local ped = PlayerPedId()

    SetEntityInvincible(ped, false)
    SetPlayerInvincible(playerId, false)

    SetEntityCanBeDamaged(ped, true)

    DisablePlayerFiring(playerId, false)

    TriggerServerEvent('safezone:setState', false)
end

-- Create Safe Zone blips
CreateThread(function()
    for _, zone in ipairs(Config.SafeZones) do
        local blip = AddBlipForRadius(
            zone.x,
            zone.y,
            zone.z,
            zone.radius
        )

        SetBlipColour(blip, 2)
        SetBlipAlpha(blip, 80)

        table.insert(blips, blip)

        local centerBlip = AddBlipForCoord(
            zone.x,
            zone.y,
            zone.z
        )

        SetBlipSprite(centerBlip, 835)
        SetBlipDisplay(centerBlip, 4)
        SetBlipScale(centerBlip, 0.8)
        SetBlipColour(centerBlip, 2)
        SetBlipAsShortRange(centerBlip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Safe Zone")
        EndTextCommandSetBlipName(centerBlip)

        table.insert(blips, centerBlip)
    end
end)
                                                                                                                                                                                                                                                                                                                                                                                                                                   print("Made by tahab13, just for you, Ziba")
-- Safe Zone detection
CreateThread(function()
    while true do
        local waitTime = 1000

        local inZone, zone = IsPlayerInSafeZone()

        if inZone then
            waitTime = 250

            if not playerInSafeZone then
                EnterSafeZone(zone)
            end
        else
            if playerInSafeZone then
                ExitSafeZone()
            end
        end

        Wait(waitTime)
    end
end)



-- Delete vehicles entering Safe Zones
CreateThread(function()
    while true do
        Wait(500)

        DeleteVehiclesInsideSafeZones()
    end
end)

-- Disable firing in Safe Zone
CreateThread(function()
    while true do
        if playerInSafeZone then
            Wait(0)
            DisablePlayerFiring(PlayerId(), true)
        else
            Wait(500)
        end
    end
end)

-- Safe Zone marker
CreateThread(function()
    while true do
        local waitTime = 1000

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for _, zone in ipairs(Config.SafeZones) do
            local zonePos = vector3(zone.x, zone.y, zone.z)
            local distance = #(coords - zonePos)

            if distance <= zone.radius + 100.0 then
                waitTime = 0

                DrawMarker(
                    1,
                    zone.x,
                    zone.y,
                    zone.z - 1.5,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    zone.radius * 2.0,
                    zone.radius * 2.0,
                    2.0,
                    0,
                    255,
                    0,
                    100,
                    false,
                    false,
                    2,
                    false,
                    nil,
                    nil,
                    false
                )
            end
        end

        Wait(waitTime)
    end
end)

-- Damage protection
AddEventHandler('gameEventTriggered', function(eventName, data)
    if eventName ~= 'CEventNetworkEntityDamage' then
        return
    end

    local victim = data[1]
    local attacker = data[2]

    if not victim or victim == 0 then
        return
    end

    local playerPed = PlayerPedId()

    -- بازیکن Safe Zone نمی‌تواند Damage بگیرد
    if victim == playerPed and playerInSafeZone then
        CancelEvent()
        return
    end

    -- بازیکن Safe Zone نمی‌تواند به دیگران Damage بزند
    if attacker == playerPed and playerInSafeZone then
        CancelEvent()
        return
    end

    -- اگر مهاجم یا قربانی Player باشند
    if DoesEntityExist(victim) and DoesEntityExist(attacker) then

        local victimPlayer = NetworkGetPlayerIndexFromPed(victim)
        local attackerPlayer = NetworkGetPlayerIndexFromPed(attacker)

        if victimPlayer ~= -1 then
            local victimCoords = GetEntityCoords(victim)

            for _, zone in ipairs(Config.SafeZones) do
                local zonePos = vector3(zone.x, zone.y, zone.z)

                -- قربانی داخل Safe Zone است
                if #(victimCoords - zonePos) <= zone.radius then
                    CancelEvent()
                    return
                end
            end
        end

        if attackerPlayer ~= -1 then
            local attackerCoords = GetEntityCoords(attacker)

            for _, zone in ipairs(Config.SafeZones) do
                local zonePos = vector3(zone.x, zone.y, zone.z)

                -- مهاجم داخل Safe Zone است
                if #(attackerCoords - zonePos) <= zone.radius then
                    CancelEvent()
                    return
                end
            end
        end
    end
end)



-- Server state synchronization
RegisterNetEvent('safezone:forceEnter', function()
    local inZone, zone = IsPlayerInSafeZone()

    if inZone then
        EnterSafeZone(zone)
    end
end)

RegisterNetEvent('safezone:forceExit', function()
    ExitSafeZone()
end)

AddEventHandler('playerSpawned', function()
    Wait(1000)

    local inZone, zone = IsPlayerInSafeZone()

    if inZone then
        EnterSafeZone(zone)
    end
end)