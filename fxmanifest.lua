fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'fabzhii'
description 'F-Jewelry by fabzhii'
version '1.0.0'

shared_script '@es_extended/imports.lua'
shared_script '@ox_lib/init.lua'

server_scripts {
    'config.lua',
    'server.lua',
}

client_scripts {
    'config.lua',
    'client.lua',
} 

dependencies {
	'ox_lib',
}