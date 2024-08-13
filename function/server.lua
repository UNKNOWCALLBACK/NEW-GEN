ESX = Config.BaseServerServerx()
local NewPlayer = {}



RegisterServerEvent('esx_identity:NewPlayer')
AddEventHandler('esx_identity:NewPlayer', function(token)
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
if token == config.tokentogetitem then
	if Config.Item ~= nil and NewPlayer[identifier] then
		NewPlayer[identifier] = false
		for k,v in pairs(Config.Item) do
			if math.random(0, 100) <= v.Percent then
				xPlayer.addInventoryItem(v.ItemName, v.ItemCount)
			end
		end
	else
        Conifg.cheatdetech(_source,xPlayer,token)
    end
else
    Conifg.cheatdetech(_source,xPlayer,token)
end
end)

-- Helper function to create an empty identity
local function createEmptyIdentity()
    return {
        identifier = '',
        firstname = '',
        lastname = '',
        dateofbirth = '',
        sex = '',
        height = ''
    }
end

-- Fetch identity data based on configuration
function getIdentity(source, callback)
    local xPlayer = ESX.GetPlayerFromId(source)
    local query = 'SELECT identifier, firstname, lastname, dateofbirth, sex' 
    local params = { ['@identifier'] = xPlayer.identifier }

    if Config.useheight and Config.ifusemysqldatabase then
        query = query .. ', height FROM `users` WHERE `identifier` = @identifier'
    else
        query = query .. ' FROM `users` WHERE `identifier` = @identifier'
    end

    MySQL.Async.fetchAll(query, params, function(result)
        local data = result[1] or createEmptyIdentity()
        callback(data)
    end)
end

-- Update identity based on configuration
function setIdentity(identifier, data, callback)
    local params = {
        ['@identifier'] = identifier,
        ['@firstname'] = data.firstname,
        ['@lastname'] = data.lastname,
        ['@dateofbirth'] = data.dateofbirth,
        ['@sex'] = data.sex
    }
    local query

    if Config.ifusemysqldatabase and not Config.ifusemongodbdatabase then
        if Config.useheight then
            params['@height'] = data.height
            query = 'UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier'
        else
            query = 'UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex WHERE identifier = @identifier'
        end

        MySQL.Async.execute(query, params, function(rowsChanged)
            callback(rowsChanged > 0)
        end)

    elseif Config.ifusemongodbdatabase and not Config.ifusemysqldatabase then
        local updateFields = {
            firstname = data.firstname,
            lastname = data.lastname,
            dateofbirth = data.dateofbirth,
            sex = data.sex
        }

        if Config.useheight then
            updateFields.height = data.height
        end

        MongoDB.Async.updateOne({
            collection = 'users',
            query = { identifier = identifier },
            update = { ['$set'] = updateFields }
        }, function(success, result)
            callback(success and result.modifiedCount > 0)
        end)
    end
end

-- Update identity for a player based on configuration
function updateIdentity(playerId, data, callback)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    if Config.ifusemongodbdatabase and not Config.ifusemysqldatabase then
        local updateFields = {
            firstname = data.firstname,
            lastname = data.lastname,
            dateofbirth = data.dateofbirth,
            sex = data.sex
        }

        if Config.useheight then
            updateFields.height = data.height
        end

        MongoDB.Async.updateOne({
            collection = 'users',
            query = { identifier = xPlayer.identifier },
            update = { ['$set'] = updateFields }
        }, function(success, result)
            if success and result.modifiedCount > 0 then
                TriggerEvent('esx_identity:characterUpdated', playerId, data)
                callback(true)
            else
                Print("[" .. GetCurrentResourceName() .. "] : ERROR FROM SERVER (mongodb update failed)")
                callback(false)
            end
        end)
    elseif Config.ifusemysqldatabase and not Config.ifusemongodbdatabase then
        local params = {
            ['@identifier'] = xPlayer.identifier,
            ['@firstname'] = data.firstname,
            ['@lastname'] = data.lastname,
            ['@dateofbirth'] = data.dateofbirth,
            ['@sex'] = data.sex
        }
        
        local query
        if Config.useheight then
            params['@height'] = data.height
            query = 'UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier'
        else
            query = 'UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex WHERE identifier = @identifier'
        end

        MySQL.Async.execute(query, params, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerEvent('esx_identity:characterUpdated', playerId, data)
                callback(true)
            else
                callback(false)
            end
        end)
    end
end

-- Delete identity based on configuration
function deleteIdentity(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local params = {
        ['@identifier'] = xPlayer.identifier,
        ['@firstname'] = '',
        ['@lastname'] = '',
        ['@dateofbirth'] = '',
        ['@sex'] = ''
    }
    local query

    if Config.ifusemysqldatabase and not Config.ifusemongodbdatabase then
        if Config.useheight then
            params['@height'] = ''
            query = 'UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier'
        else
            query = 'UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex WHERE identifier = @identifier'
        end

        MySQL.Async.execute(query, params, function() end)

    elseif Config.ifusemongodbdatabase and not Config.ifusemysqldatabase then
        local updateFields = {
            firstname = '',
            lastname = '',
            dateofbirth = '',
            sex = ''
        }

        if Config.useheight then
            updateFields.height = ''
        end

        MongoDB.Async.updateOne({
            collection = 'users',
            query = { identifier = xPlayer.identifier },
            update = { ['$set'] = updateFields }
        }, function(success, result)
            if not (success and result.modifiedCount > 0) then
                Print("[" .. GetCurrentResourceName() .. "] : ERROR FROM SERVER (mongodb update failed)")
            end
        end)
    end
end







RegisterServerEvent('esx_identity:setIdentity')
AddEventHandler('esx_identity:setIdentity', function(data, myIdentifiers)
	local xPlayer = ESX.GetPlayerFromId(source)
	setIdentity(myIdentifiers.steamid, data, function(callback)
		if callback then
			NewPlayer[myIdentifiers.steamid] = true
			TriggerClientEvent('esx_identity:identityCheck', myIdentifiers.playerid, true)
			TriggerEvent('esx_identity:characterUpdated', myIdentifiers.playerid, data)
		else
		Config.customnotify(xPlayer)
		end
	end)
end)


AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local myID = {
		steamid = xPlayer.identifier,
		playerid = playerId
	}

	TriggerClientEvent('esx_identity:saveID', playerId, myID)

	getIdentity(playerId, function(data)
		if data.firstname == '' then
			TriggerClientEvent('esx_identity:identityCheck', playerId, false)
			TriggerClientEvent('esx_identity:showRegisterIdentity', playerId)
		else
			TriggerClientEvent('esx_identity:identityCheck', playerId, true)
			TriggerEvent('esx_identity:characterUpdated', playerId, data)
		end
	end)
end)





local usescript = false  -- ตัวแปรสำหรับบอกว่าต้องใช้สคริปต์หรือไม่

-- ฟังก์ชันที่ใช้ตรวจสอบการตั้งค่า
local function checkConfig()
    if Config.ifusemongodbdatabase and Config.ifusemysqldatabase then
        usescript = false
    else
        usescript = true
    end
end

-- ฟังก์ชันที่ใช้เริ่มต้นงานต่าง ๆ
local function startScript()
    AddEventHandler('esx_identity:characterUpdated', function(playerId, data)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            xPlayer.setName(('%s %s'):format(data.firstname, data.lastname))
            xPlayer.set('firstName', data.firstname)
            xPlayer.set('lastName', data.lastname)
            xPlayer.set('dateofbirth', data.dateofbirth)
            xPlayer.set('sex', data.sex)
            if Config.height then
                xPlayer.set('height', data.height)
            end
        end
    end)

    -- Set all the client side variables for connected users one new time
    AddEventHandler('onResourceStart', function(resource)
        if resource == GetCurrentResourceName() then
            Citizen.Wait(3000)
            local xPlayers = ESX.GetPlayers()

            for i=1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

                if xPlayer then
                    local myID = {
                        steamid  = xPlayer.identifier,
                        playerid = xPlayer.source
                    }
        
                    TriggerClientEvent('esx_identity:saveID', xPlayer.source, myID)
        
                    getIdentity(xPlayer.source, function(data)
                        if data.firstname == '' then
                            TriggerClientEvent('esx_identity:identityCheck', xPlayer.source, false)
                            TriggerClientEvent('esx_identity:showRegisterIdentity', xPlayer.source)
                        else
                            TriggerClientEvent('esx_identity:identityCheck', xPlayer.source, true)
                            TriggerEvent('esx_identity:characterUpdated', xPlayer.source, data)
                        end
                    end)
                end
            end
        end
    end)
end

Citizen.CreateThread(function()
    checkConfig()  -- ตรวจสอบการตั้งค่าเมื่อเริ่มต้น
    if usescript then
        startScript()  -- เริ่มทำงานสคริปต์ถ้าจำเป็น
    else
        print("Script is disabled due to configuration settings.")
    end
end)
