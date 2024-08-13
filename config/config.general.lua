Config = {} or nil

Config.minect = 5 -- จำนวนตัวอักษรขั้นต่ำของชื่อ - นามสกุล

Config.useheight = false --boolean ห้ามลบ กรณีใช้ false ให้ลบ colunm height ออกด้วย
--[[
functionนี้ คือ function ที่จะทำการลดปริมาญการเก็บข้อมูลลง database
    โดยจำเป็ต้องแก้ es_extended ดังนี้
    server บรรทัดที่ 5 - 10
        local newPlayer = "INSERT INTO `users` SET `accounts` = ?, `identifier` = ?, `group` = ?"
        local loadPlayer = "SELECT `accounts`, `job`, `job_grade`, `group`, `position`, `inventory`, `skin`, `loadout`, `metadata`"

        if Config.Multichar then
            newPlayer = newPlayer .. ", `firstname` = ?, `lastname` = ?, `dateofbirth` = ?, `sex` = ?"
        end
    สามารถก็อบไปวางได้เลย es_extended 1.10.7
]]


Config.customnotify = function(xPlayer) -- custom การใช้งานสคริป notify ของท่าน
    xPlayer.showNotification('failed to set your character, try again later or contact the server admin!')
end