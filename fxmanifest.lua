fx_version 'adamant'

game 'gta5'

lua54 'yes'

description 'ESX Identity edit by unknowcallback'

version '1.2.0'

server_scripts {
			'config/*.lua',
	'function/server.lua'
	'@mysql-async/lib/MySQL.lua',
--    '@mongodb/lib/MongoDB.lua', --กรณีใช้mongodbให้ลบบรรทัด 12 ออกและเปิด commant นี้

}

client_scripts {
	'config/*.lua',
	'function/client.lua'
}


ui_page "web/ui.html"

files {
    "web/**"
}

dependency 'es_extended'