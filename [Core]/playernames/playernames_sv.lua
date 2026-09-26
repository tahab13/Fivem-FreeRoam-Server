local curTemplate
local curTags = {}

local activePlayers = {}

local function detectUpdates()
    SetTimeout(500, detectUpdates)

    local template = GetConvar('playerNames_template', '[{{id}}] {{name}}')
    
    if curTemplate ~= template then
        setNameTemplate(-1, template)

        curTemplate = template
    end

    template = GetConvar('playerNames_svTemplate', '[{{id}}] {{name}}')

    for v, _ in pairs(activePlayers) do
        local newTag = formatPlayerNameTag(v, template)
        if newTag ~= curTags[v] then
            setName(v, newTag)
            
            curTags[v] = newTag
        end
    end

    for i, tag in pairs(curTags) do
        if not activePlayers[i] then
            curTags[i] = nil
        end
    end
end

AddEventHandler('playerDropped', function()
    curTags[source] = nil
    activePlayers[source] = nil
    TriggerClientEvent('playernames:playerDropped', -1, source)
end)

RegisterNetEvent('playernames:init')
AddEventHandler('playernames:init', function()
    reconfigure(source)
    activePlayers[source] = true
end)

local function syncPlayerPositions()
    SetTimeout(2000, syncPlayerPositions)
    
    local players = GetPlayers()
    local playerData = {}
    
    for _, serverId in ipairs(players) do
        local ped = GetPlayerPed(tonumber(serverId))
        if DoesEntityExist(ped) then
            local coords = GetEntityCoords(ped)
            local name = GetPlayerName(tonumber(serverId))
            playerData[serverId] = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
                name = name
            }
        end
    end
    
    for _, serverId in ipairs(players) do
        local dataToSend = {}
        for sid, data in pairs(playerData) do
            if tonumber(sid) ~= tonumber(serverId) then
                dataToSend[sid] = data
            end
        end
        TriggerClientEvent('playernames:syncPositions', tonumber(serverId), dataToSend)
    end
end

detectUpdates()
syncPlayerPositions()
