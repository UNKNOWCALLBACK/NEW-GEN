Config = {} or nil

Config.ifusemysqldatabase = false --กรณีใช้ฐานข้อมูล MYSQL

Config.ifusemongodbdatabase = false --กรณีใช้ฐานข้อมูล MONGODB

--[[
Config สองตัวนี้จะทำงานพร้อมกับ server.lua โดยถ้า set function ทั้งสองเป็น true ทั้งคู่จะทำให้ server error และไม่สามารถทำงานได้
    กรุณาเลือกอย่างใดอย่างหนึ่ง
]]