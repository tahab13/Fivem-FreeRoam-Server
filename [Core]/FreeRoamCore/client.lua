print("Core loaded")                                                                                                                                                                                                                                                                                                                                                                                                                                   print("Made by tahab13, just for you, Ziba")

-- Revive - key: E
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsEntityDead(ped) then
            if IsControlJustPressed(0, 38) then
                NetworkResurrectLocalPlayer(GetEntityCoords(ped), true, true, false)
                ClearPedTasksImmediately(ped)
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)

-- Open PvP
CreateThread(function()
    while true do
        Wait(100)
        NetworkSetFriendlyFireOption(true)
    end
end)

-- tp
for _, tp in ipairs(Config.Teleports) do
    RegisterCommand(tp.command, function()
        local ped = PlayerPedId()
        SetEntityCoords(ped, tp.coords.x, tp.coords.y, tp.coords.z, false, false, false, true)
        SetEntityHeading(ped, tp.coords.w)
    end)
end

local lastFixTime = 0
local lastSpawnTime = 0
local lastVehicle = nil

-- car vehiclename | Spawn Vehicle
RegisterCommand('car', function(source, args)
    if not args[1] then return end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    if lastVehicle and DoesEntityExist(lastVehicle) then
        if GetPedInVehicleSeat(lastVehicle, -1) ~= ped then
            DeleteEntity(lastVehicle)
        end
    end
    
    local model = GetHashKey(args[1])
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    SetPedIntoVehicle(ped, vehicle, -1)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleDirtLevel(vehicle, 0.0)
    
    lastVehicle = vehicle
    SetModelAsNoLongerNeeded(model)
end)

-- fix | fix vehicle (5s cooldown)
RegisterCommand('fix', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if not vehicle then return end
    
    if GetGameTimer() - lastFixTime < 5000 then
        return
    end
    
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true, false)
    
    lastFixTime = GetGameTimer()
end)

-- dv | delete vehicle
RegisterCommand('dv', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if not vehicle then return end
    
    if GetPedInVehicleSeat(vehicle, -1) == ped then
        DeleteEntity(vehicle)
        if lastVehicle == vehicle then
            lastVehicle = nil
        end
    end
end)

-- armour | 100% armour
RegisterCommand('armour', function()
    local ped = PlayerPedId()
    SetPedArmour(ped, 100)
end)



-- Clear World
CreateThread(function()
    while true do
        Wait(3000)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, vehicle in ipairs(GetGamePool('CVehicle')) do
            if DoesEntityExist(vehicle) then
                local vehicleCoords = GetEntityCoords(vehicle)
                local distance = #(playerCoords - vehicleCoords)

                if distance <= 150.0 then
                    local fuelTankHealth = GetVehiclePetrolTankHealth(vehicle)

                    if fuelTankHealth <= 0.0 then
                        SetEntityAsMissionEntity(vehicle, true, true)
                        DeleteVehicle(vehicle)

                        print(("Deleted vehicle with Fuel Tank Health: %.2f"):format(fuelTankHealth))
                    end
                end
            end
        end
    end
end)

-- infinity AMMO
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        for i = -1, 5 do
            SetPedInfiniteAmmo(ped, true, i)
        end
        Wait(1000)
    end
end)
