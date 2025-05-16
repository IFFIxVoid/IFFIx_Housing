fx_version 'cerulean'
game 'gta5'

author 'IFFIx Team'
description 'Combined Housing and Realtor system for QBX'

shared_scripts {
    'shared/housing.lua',
    'shared/realtor.lua',
    'config.lua',
}

client_scripts {
    'client/housing.lua',
    'client/realtor.lua',
}

server_scripts {
    'server/housing.lua',
    'server/realtor.lua',
}

dependencies {
    'qbx_core',
}
