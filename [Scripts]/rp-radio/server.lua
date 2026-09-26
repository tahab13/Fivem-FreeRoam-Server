local function setPlayerHasRadio(source, has)
 	TriggerClientEvent('Radio.Set', source, has and true or false)
 end
 
 exports('setPlayerHasRadio', setPlayerHasRadio)
 
 RegisterNetEvent('checkradio', function()
 	setPlayerHasRadio(source, true)
 	TriggerClientEvent('doeshaveradio', source)
 end)