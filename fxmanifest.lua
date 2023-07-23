fx_version 'cerulean'
game 'gta5'

author 'AglioB'
description 'Vip system - QBCore'


server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
	'lang.lua'
}

client_scripts {
	'client.lua'
}

dependencies {
    'qb-core',
	'ox_lib',
    'oxmysql'
}

lua54 'yes'