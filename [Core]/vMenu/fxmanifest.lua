
fx_version 'bodacious'
games {'gta5'}

name 'vMenu'
description 'Server sided trainer for FiveM with custom permissions, using a custom MenuAPI. More info can be found at www.vespura.com/fivem'
version 'v3.7.0'
author 'Tom Grobbe | Edited by tahab13 for FreeRoam'
url 'https://github.com/TomGrobbe/vMenu/'
ui_page 'storage.html'

client_debug_mode 'false'
server_debug_mode 'false'

experimental_features_enabled '0'

files {
    'Newtonsoft.Json.dll',
    'MenuAPI.dll',
    'config/locations.json',
    'config/character_ignores.json',
    'config/addons.json',
    'storage.html'
}

client_scripts {
    'vMenuClient.net.dll',
}

server_scripts {
    'vMenuServer.net.dll',
}
