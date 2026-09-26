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

local fallbackDefaultSkin = {
    model = 1885233650,
    decorations = {},
    eyecolor = 0,
    hair = { highlight = 0, color = 0 },
    facefeatures = {
        ['0'] = 0.0, ['1'] = 0.0, ['2'] = 0.0, ['3'] = 0.0, ['4'] = 0.0, ['5'] = 0.0,
        ['6'] = 0.0, ['7'] = 0.0, ['8'] = 0.0, ['9'] = 0.0, ['10'] = 0.0, ['11'] = 0.0,
        ['12'] = 0.0, ['13'] = 0.0, ['14'] = 0.0, ['15'] = 0.0, ['16'] = 0.0, ['17'] = 0.0,
        ['18'] = 0.0, ['19'] = 0.0
    },
    overlays = {
        ['0'] = { opacity = 1.0, value = 255 },
        ['1'] = { opacity = 1.0, value = 255 },
        ['2'] = { opacity = 1.0, value = 255 },
        ['3'] = { opacity = 1.0, value = 255 },
        ['4'] = { opacity = 1.0, value = 255 },
        ['5'] = { opacity = 1.0, value = 255 },
        ['6'] = { opacity = 1.0, value = 255 },
        ['7'] = { opacity = 1.0, value = 255 },
        ['8'] = { opacity = 1.0, value = 255 },
        ['9'] = { opacity = 1.0, value = 255 },
        ['10'] = { opacity = 1.0, value = 255 },
        ['11'] = { opacity = 1.0, value = 255 },
        ['12'] = { opacity = 1.0, value = 255 }
    },
    props = {
        ['0'] = { prop = -1, texture = -1 },
        ['1'] = { prop = -1, texture = -1 },
        ['2'] = { prop = -1, texture = -1 },
        ['3'] = { prop = -1, texture = -1 },
        ['4'] = { prop = -1, texture = -1 },
        ['5'] = { prop = -1, texture = -1 },
        ['6'] = { prop = -1, texture = -1 },
        ['7'] = { prop = -1, texture = -1 }
    },
    components = {
        ['0'] = { palette = 0, drawable = 0, texture = 0 },
        ['1'] = { palette = 0, drawable = 28, texture = 0 },
        ['2'] = { palette = 0, drawable = 0, texture = 0 },
        ['3'] = { palette = 0, drawable = 38, texture = 0 },
        ['4'] = { palette = 0, drawable = 33, texture = 0 },
        ['5'] = { palette = 0, drawable = 0, texture = 0 },
        ['6'] = { palette = 0, drawable = 25, texture = 0 },
        ['7'] = { palette = 0, drawable = 0, texture = 0 },
        ['8'] = { palette = 0, drawable = 15, texture = 0 },
        ['9'] = { palette = 0, drawable = 0, texture = 0 },
        ['10'] = { palette = 0, drawable = 0, texture = 0 },
        ['11'] = { palette = 0, drawable = 328, texture = 0 }
    }
}

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

local function applySkin(ped, skin)
    if not skin then return end

    for k, v in pairs(skin.facefeatures) do
        SetPedFaceFeature(ped, tonumber(k), v)
    end

    for k, v in pairs(skin.overlays) do
        SetPedHeadOverlay(ped, tonumber(k), v.value, v.opacity)
    end

    for k, v in pairs(skin.props) do
        if v.prop == -1 then
            ClearPedProp(ped, tonumber(k))
        else
            SetPedPropIndex(ped, tonumber(k), v.prop, v.texture, true)
        end
    end

    for k, v in pairs(skin.components) do
        SetPedComponentVariation(ped, tonumber(k), v.drawable, v.texture, v.palette)
    end

    SetPedEyeColor(ped, skin.eyecolor)
    SetPedHairColor(ped, skin.hair.color, skin.hair.highlight)

    for i = 1, #skin.decorations do
        local decoration = skin.decorations[i]
        AddPedDecorationFromHashesInCache(ped, GetHashKey(decoration[1]), GetHashKey(decoration[2]))
    end
end

local function giveAllWeapons(ped)
    local weapons = {
        -- Melee
        `WEAPON_KNIFE`,
        `WEAPON_NIGHTSTICK`,
        `WEAPON_HAMMER`,
        `WEAPON_BAT`,
        `WEAPON_CROWBAR`,
        `WEAPON_GOLFCLUB`,
        `WEAPON_BOTTLE`,
        `WEAPON_DAGGER`,
        `WEAPON_HATCHET`,
        `WEAPON_MACHETE`,
        `WEAPON_FLASHLIGHT`,
        `WEAPON_SWITCHBLADE`,
        `WEAPON_POOLCUE`,
        `WEAPON_WRENCH`,
        `WEAPON_BATTLEAXE`,
        `WEAPON_STONE_HATCHET`,
        `WEAPON_CANDYCANE`,
        `WEAPON_STUNROD`,
        `WEAPON_KNUCKLE`,

        -- Pistols
        `WEAPON_PISTOL`,
        `WEAPON_PISTOL_MK2`,
        `WEAPON_COMBATPISTOL`,
        `WEAPON_APPISTOL`,
        `WEAPON_PISTOL50`,
        `WEAPON_SNSPISTOL`,
        `WEAPON_SNSPISTOL_MK2`,
        `WEAPON_HEAVYPISTOL`,
        `WEAPON_VINTAGEPISTOL`,
        `WEAPON_MARKSMANPISTOL`,
        `WEAPON_REVOLVER`,
        `WEAPON_REVOLVER_MK2`,
        `WEAPON_DOUBLEACTION`,
        `WEAPON_FLAREGUN`,
        `WEAPON_RAYPISTOL`,
        `WEAPON_CERAMICPISTOL`,
        `WEAPON_GADGETPISTOL`,
        `WEAPON_NAVYREVOLVER`,
        `WEAPON_PISTOLXM3`,

        -- SMGs
        `WEAPON_MICROSMG`,
        `WEAPON_SMG`,
        `WEAPON_SMG_MK2`,
        `WEAPON_ASSAULTSMG`,
        `WEAPON_COMBATPDW`,
        `WEAPON_MACHINEPISTOL`,
        `WEAPON_MINISMG`,
        `WEAPON_TECPISTOL`,

        -- Shotguns
        `WEAPON_PUMPSHOTGUN`,
        `WEAPON_PUMPSHOTGUN_MK2`,
        `WEAPON_SAWNOFFSHOTGUN`,
        `WEAPON_ASSAULTSHOTGUN`,
        `WEAPON_BULLPUPSHOTGUN`,
        `WEAPON_HEAVYSHOTGUN`,
        `WEAPON_DBSHOTGUN`,
        `WEAPON_AUTOSHOTGUN`,
        `WEAPON_COMBATSHOTGUN`,

        -- Assault Rifles
        `WEAPON_ASSAULTRIFLE`,
        `WEAPON_ASSAULTRIFLE_MK2`,
        `WEAPON_CARBINERIFLE`,
        `WEAPON_CARBINERIFLE_MK2`,
        `WEAPON_ADVANCEDRIFLE`,
        `WEAPON_SPECIALCARBINE`,
        `WEAPON_SPECIALCARBINE_MK2`,
        `WEAPON_BULLPUPRIFLE`,
        `WEAPON_BULLPUPRIFLE_MK2`,
        `WEAPON_COMPACTRIFLE`,
        `WEAPON_MILITARYRIFLE`,
        `WEAPON_HEAVYRIFLE`,
        `WEAPON_TACTICALRIFLE`,
        `WEAPON_BATTLERIFLE`,

        -- Machine Guns
        `WEAPON_MG`,
        `WEAPON_COMBATMG`,
        `WEAPON_COMBATMG_MK2`,
        `WEAPON_GUSENBERG`,
        `WEAPON_RAYCARBINE`,

        -- Snipers / Marksman
        `WEAPON_SNIPERRIFLE`,
        `WEAPON_HEAVYSNIPER`,
        `WEAPON_HEAVYSNIPER_MK2`,
        `WEAPON_MARKSMANRIFLE`,
        `WEAPON_MARKSMANRIFLE_MK2`,
        `WEAPON_PRECISIONRIFLE`,
        `WEAPON_MUSKET`,

        -- Heavy Weapons
        `WEAPON_RPG`,
        `WEAPON_GRENADELAUNCHER`,
        `WEAPON_GRENADELAUNCHER_SMOKE`,
        `WEAPON_MINIGUN`,
        `WEAPON_FIREWORK`,
        `WEAPON_RAILGUN`,
        `WEAPON_RAILGUNXM3`,
        `WEAPON_HOMINGLAUNCHER`,
        `WEAPON_COMPACTLAUNCHER`,
        `WEAPON_RAYMINIGUN`,
        `WEAPON_EMPLAUNCHER`,
        `WEAPON_SNOWLAUNCHER`,

        -- Throwables
        `WEAPON_GRENADE`,
        `WEAPON_BZGAS`,
        `WEAPON_TEARGAS`,
        `WEAPON_MOLOTOV`,
        `WEAPON_STICKYBOMB`,
        `WEAPON_PROXMINE`,
        `WEAPON_SNOWBALL`,
        `WEAPON_PIPEBOMB`,
        `WEAPON_BALL`,
        `WEAPON_SMOKEGRENADE`,
        `WEAPON_FLARE`,
        `WEAPON_ACIDPACKAGE`,

        -- Stun / Special
        `WEAPON_STUNGUN`,
        `WEAPON_STUNGUN_MP`,
        --`WEAPON_HACKINGDEVICE`,

        -- Tools
        `WEAPON_PETROLCAN`,
        `WEAPON_HAZARDCAN`,
        `WEAPON_FERTILIZERCAN`,
        `WEAPON_FIREEXTINGUISHER`,
        --`WEAPON_METALDETECTOR`,

        -- Parachute
        `WEAPON_PARACHUTE`,
    }

    for _, weapon in ipairs(weapons) do
        GiveWeaponToPed(ped, weapon, 9999, false, true)
    end

    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
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

        applySkin(ped, fallbackDefaultSkin)
        giveAllWeapons(ped)

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
