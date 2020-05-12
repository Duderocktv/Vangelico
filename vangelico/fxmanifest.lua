fx_version 'adamant'

game 'gta5'

client_scripts {  
  'config.lua',
  'utils.lua', 
	'Client/ClientMain.lua',
}

server_scripts { 
  '@mysql-async/lib/MySQL.lua', 
	'config.lua',
  'utils.lua',
  'Server/PoliceCount.lua', 
  'Server/ServerMain.lua', 
}

 
dependencies {
  'safecracker',
  'mhacking', 
  'lockpicking',
}
