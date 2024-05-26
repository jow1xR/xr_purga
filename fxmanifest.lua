
fx_version 'cerulean'
game 'gta5'

description 'Script para hacer purgas en tu servidor'
version '1.0.0'

author "XR | j0w1_xR"
files {
    "html/ui.html",
    "html/assets/css/*.css",
    "html/assets/js/*.js",
    "html/assets/img/*.png",
    "html/assets/sound/*.mp3"
}
ui_page "html/ui.html"

--Put this if you use a recent version of ESX LEGACY! --

-- shared_script '@es_extended/imports.lua'

client_script '**/client.lua'

server_script {
    'config.lua',
    '**/server.lua'
}