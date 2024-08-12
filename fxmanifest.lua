fx_version 'adamant'

game 'gta5'

lua54 'yes'

description 'ESX Identity'

version '1.2.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
--    '@mongodb/lib/MongoDB.lua', --กรณีใช้mongodbให้ลบบรรทัด 12 ออกและเปิด commant นี้

}

client_scripts {
	'config.lua',
	'client/main.lua'
}

ui_page "web/ui.html"

files {
    "web/**"
}

dependency 'es_extended'