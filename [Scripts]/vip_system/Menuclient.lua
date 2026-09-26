local spjumpst = false
local spjumpThread = nil
local nvWantedst = false
local GodModSt = '~r~off'
local GodModThread = nil
local spjump = '~r~off'
local farun = '~r~off'
local nvWanted = '~r~off'
local currentHour = 9
local currentWeather = 'CLEAR'

AddEventHandler('playerSpawned', function()
    NetworkOverrideClockTime(currentHour, 0, 0)
    SetWeatherTypeOverTime(currentWeather, 0.0)
    SetWeatherTypePersist(currentWeather)
end)
--warmenu
function CreateWarMenu(id, title, subtitle, pos, width)
    local x,y = table.unpack(pos)
    WarMenu.CreateMenu(id, title)
    WarMenu.SetSubTitle(id, subtitle)
    WarMenu.SetMenuX(id, x)
    WarMenu.SetMenuY(id, y)
    WarMenu.SetMenuWidth(id, width)
    WarMenu.SetTitleColor(id, 255, 255, 255, a)
end
--notif
function ShowNotification( text )
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end
--command
RegisterCommand("VipC", function (source,args)
	TriggerServerEvent('pervip')
end)
-----------------------perm
RegisterNetEvent('Spervip')
AddEventHandler('Spervip', function()
	WarMenu.OpenMenu('Vipmenu')
end)
-----------------------OpenMenu
RegisterKeyMapping('VipC', 'vip Menu', 'keyboard', 'F2')
--Menu
Citizen.CreateThread(function()
    CreateWarMenu('Vipmenu', 'VipMenu', 'Vip Menu', {0.7, 0.2}, 1.0)
    CreateWarMenu('CarsPeds', 'Cars$Peds', 'Cars$Peds', {0.7, 0.2}, 1.0)
    CreateWarMenu('Cars', 'Cars', 'Cars', {0.7, 0.2}, 1.0)
    CreateWarMenu('Peds', 'Peds', 'Peds', {0.7, 0.2}, 1.0)
    CreateWarMenu('Time', 'Time', 'Time', {0.7, 0.2}, 1.0)
    CreateWarMenu('Weather', 'Weather', 'Weather', {0.7, 0.2}, 1.0)
    while true do
        Citizen.Wait(0)
        if WarMenu.IsMenuOpened('Vipmenu') then
            if WarMenu.Button('~g~Teleport To Waypoint') then
                local WaypointHandle = GetFirstBlipInfoId(8)
                if DoesBlipExist(WaypointHandle) then
                    local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
                    for height = 1, 1000 do
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords['x'], waypointCoords['y'], height + 0.0)
                        local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords['x'], waypointCoords['y'], height + 0.0)
                        if foundGround then
                            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords['x'], waypointCoords['y'], height + 0.0)
                            break
                        end
                        Wait(1)
                    end
                end
            end
            if WarMenu.Button('~y~Cars$Peds', '>>>') then
                WarMenu.OpenMenu('CarsPeds')
            end
            if WarMenu.Button('Time', '>>>') then
                WarMenu.OpenMenu('Time')
            end
            if WarMenu.Button('Weather', '>>>') then
                WarMenu.OpenMenu('Weather')
            end
            if WarMenu.Button('GodMod',GodModSt) then
                if GodModSt == '~r~off' then
                    GodModSt = '~g~on'
                    SetPlayerInvincible(PlayerId(), true)
                    GodModThread = Citizen.CreateThread(function()
                        while GodModSt == '~g~on' do
                            DisablePlayerFiring(PlayerId(), true)
                            local playerPed = PlayerPedId()
                            local vehicles = GetGamePool('CVehicle')
                            local peds = GetGamePool('CPed')
                            for _, vehicle in ipairs(vehicles) do
                                SetEntityNoCollisionEntity(playerPed, vehicle, false)
                                SetEntityNoCollisionEntity(vehicle, playerPed, false)
                            end
                            for _, ped in ipairs(peds) do
                                if ped ~= playerPed then
                                    SetEntityNoCollisionEntity(playerPed, ped, false)
                                    SetEntityNoCollisionEntity(ped, playerPed, false)
                                end
                            end
                            Wait(0)
                        end
                    end)
                else
                    GodModSt = '~r~off'
                    SetPlayerInvincible(PlayerId(), false)
                    DisablePlayerFiring(PlayerId(), false)
                end
            end
            if WarMenu.Button('Super Jump',spjump) then
                if spjump == '~r~off' then
                    spjump = '~g~on'
                    spjumpst = true
                    spjumpThread = Citizen.CreateThread(function()
                        while spjumpst do
                            SetSuperJumpThisFrame(PlayerId())
                            Wait(1)
                        end
                    end)
                else
                    spjump = '~r~off'
                    spjumpst = false
                end
            end
            if WarMenu.Button('Fast Run',farun) then
                if farun == '~r~off' then
                    farun = '~g~on'
                    SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
                else
                    farun = '~r~off'
                    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                end
            end
            if WarMenu.Button('Never Wanted',nvWanted) then
                if nvWanted == '~r~off' then
                    nvWanted = '~g~on'
                    nvWantedst = true
                    if nvWantedst == true then
                        SetMaxWantedLevel(0)
                        local want = GetPlayerWantedLevel(PlayerId())
                        if want > 0 then
                        SetPlayerWantedLevel(PlayerId(), 0, false)
                        SetPlayerWantedLevelNow(PlayerId(), false)
                        end
                    end
                else
                    nvWanted = '~r~off'
                    SetMaxWantedLevel(5)
                end
            end
            WarMenu.Display()
        end
        if WarMenu.IsMenuOpened('CarsPeds') then
            if WarMenu.Button('Cars') then
                WarMenu.OpenMenu('Cars')
            end
            if WarMenu.Button('Ped') then
                WarMenu.OpenMenu('Peds')
            end
            WarMenu.Display()
        end
--------cars
        if WarMenu.IsMenuOpened('Cars') then
            local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.5))
            if WarMenu.Button('T20') then
                local car = CreateVehicle(0x6322B39A, x, y, z, GetEntityHeading(PlayerPedId()), true, true)
                SetVehicleDirtLevel(car, 0)
                SetPedIntoVehicle(PlayerPedId(), car, -1)
            end
            if WarMenu.Button('T20') then
                local car = CreateVehicle(0x6322B39A, x, y, z, GetEntityHeading(PlayerPedId()), true, true)
                SetVehicleDirtLevel(car, 0)
                SetPedIntoVehicle(PlayerPedId(), car, -1)
            end
            WarMenu.Display()
        end
--------peds
        if WarMenu.IsMenuOpened('Peds') then
            if WarMenu.Button('ig_amandatownley') then
            end
            WarMenu.Display()
        end
--------time
        if WarMenu.IsMenuOpened('Time') then
            for hour = 0, 23 do
                local label = tostring(hour)
                if hour == currentHour then
                    label = '~g~' .. label
                end
                if WarMenu.Button(label) then
                    currentHour = hour
                    NetworkOverrideClockTime(hour, 0, 0)
                end
            end
            WarMenu.Display()
        end
--------weather
        if WarMenu.IsMenuOpened('Weather') then
            local weatherTypes = {'CLEAR', 'EXTRASUNNY', 'CLOUDS', 'OVERCAST', 'RAIN', 'CLEARING', 'THUNDER', 'SMOG', 'FOGGY', 'XMAS', 'SNOWLIGHT', 'BLIZZARD'}
            for _, weather in ipairs(weatherTypes) do
                local displayLabel = weather
                if weather == currentWeather then
                    displayLabel = '~g~' .. displayLabel
                end
                if WarMenu.Button(displayLabel) then
                    currentWeather = weather
                    SetWeatherTypeOverTime(weather, 0.0)
                    SetWeatherTypePersist(weather)
                end
            end
            WarMenu.Display()
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		if IsControlJustPressed(0,202) then
			if WarMenu.IsMenuOpened('CarsPeds') then
				Wait(50)
				WarMenu.OpenMenu('Vipmenu')
            elseif WarMenu.IsMenuOpened('Cars') then
				Wait(50)
				WarMenu.OpenMenu('CarsPeds')
            elseif WarMenu.IsMenuOpened('Peds')  then
				Wait(50)
				WarMenu.OpenMenu('CarsPeds')
            elseif WarMenu.IsMenuOpened('Time') then
				Wait(50)
				WarMenu.OpenMenu('Vipmenu')
            elseif WarMenu.IsMenuOpened('Weather') then
				Wait(50)
				WarMenu.OpenMenu('Vipmenu')
			end
		end
		Citizen.Wait(1)
	end
end)
