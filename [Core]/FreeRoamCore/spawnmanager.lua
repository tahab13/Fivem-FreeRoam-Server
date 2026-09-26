local spawnPoints = {
    {
        x = 195.1918,
        y = -933.8562,
        z = 30.6868,
        heading = 325.1902,
        model = `mp_m_freemode_01`
    }
}

local autoSpawnEnabled = true
local autoSpawnCallback = nil
local isSpawning = false
local hasSpawned = false

local function normalizeSpawn(spawn)
    spawn = spawn or spawnPoints[1]

    local x = tonumber(spawn.x or spawn[1]) or 0.0
    local y = tonumber(spawn.y or spawn[2]) or 0.0
    local z = tonumber(spawn.z or spawn[3]) or 0.0
    local heading = tonumber(spawn.heading or spawn.h or spawn[4]) or 0.0
    local model = spawn.model or `mp_m_freemode_01`

    if type(model) == 'string' then
        model = GetHashKey(model)
    end

    return {
        x = x,
        y = y,
        z = z,
        heading = heading,
        model = model
    }
end

local function loadModel(model)
    if not IsModelInCdimage(model) then
        model = `mp_m_freemode_01`
    end

    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(0)
    end

    return model
end

function spawnPlayer(spawn, cb)
    if isSpawning then
        return
    end

    isSpawning = true

    CreateThread(function()
        spawn = normalizeSpawn(spawn)
        spawn.model = loadModel(spawn.model)

        DoScreenFadeOut(500)

        while not IsScreenFadedOut() do
            Wait(0)
        end

        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)
        NewLoadSceneStart(spawn.x, spawn.y, spawn.z, spawn.x, spawn.y, spawn.z, 50.0, 0)

        local loadTimer = GetGameTimer()
        while not IsNewLoadSceneLoaded() and GetGameTimer() - loadTimer < 5000 do
            Wait(0)
        end

        SetPlayerModel(PlayerId(), spawn.model)
        SetModelAsNoLongerNeeded(spawn.model)

        local ped = PlayerPedId()

        FreezeEntityPosition(ped, true)
        SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false)
        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, false)
        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped, true)
        ClearPlayerWantedLevel(PlayerId())
        SetEntityHeading(ped, spawn.heading)

        while not HasCollisionLoadedAroundEntity(ped) do
            Wait(0)
        end

        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()

        NewLoadSceneStop()
        FreezeEntityPosition(ped, false)

        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 3, 0, 0, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 0, 0, 0)
        SetPedPropIndex(ped, 0, -1, 0, true)

        TriggerEvent('playerSpawned', spawn)

        if cb then
            cb(spawn)
        end

        hasSpawned = true
        isSpawning = false

        DoScreenFadeIn(500)
    end)
end

function addSpawnPoint(spawn)
    spawnPoints[#spawnPoints + 1] = normalizeSpawn(spawn)
    return #spawnPoints
end

function removeSpawnPoint(index)
    spawnPoints[index] = nil
end

function loadSpawns(spawns)
    spawnPoints = {}

    for _, spawn in ipairs(spawns or {}) do
        spawnPoints[#spawnPoints + 1] = normalizeSpawn(spawn)
    end

    if #spawnPoints == 0 then
        spawnPoints[1] = normalizeSpawn()
    end
end

function setAutoSpawn(enabled)
    autoSpawnEnabled = enabled == true
end

function setAutoSpawnCallback(cb)
    autoSpawnCallback = cb
end

function forceRespawn()
    hasSpawned = false
    spawnPlayer(spawnPoints[1])
end

exports('spawnPlayer', spawnPlayer)
exports('addSpawnPoint', addSpawnPoint)
exports('removeSpawnPoint', removeSpawnPoint)
exports('loadSpawns', loadSpawns)
exports('setAutoSpawn', setAutoSpawn)
exports('setAutoSpawnCallback', setAutoSpawnCallback)
exports('forceRespawn', forceRespawn)

CreateThread(function()
    while true do
        Wait(500)

        if autoSpawnEnabled and not hasSpawned and not isSpawning and NetworkIsPlayerActive(PlayerId()) then
            if autoSpawnCallback then
                autoSpawnCallback()
            else
                spawnPlayer(spawnPoints[1])
            end
        end
    end
end)

AddEventHandler('onClientGameTypeStart', function()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end)
