ESX = nil
local NewPlayer = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



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

function getIdentity(source, callback)
	if Config.useheight == true and Config.ifusemysqldatabase == true then
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, dateofbirth, sex, height FROM `users` WHERE `identifier` = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1].firstname ~= nil then
			local data = {
				identifier	= result[1].identifier,
				firstname	= result[1].firstname,
				lastname	= result[1].lastname,
				dateofbirth	= result[1].dateofbirth,
				sex			= result[1].sex,
				height		= result[1].height
			}

			callback(data)
		else
			local data = {
				identifier	= '',
				firstname	= '',
				lastname	= '',
				dateofbirth	= '',
				sex			= '',
				height		= ''
			}

			callback(data)
		end
	end)
else
	
	MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, dateofbirth, sex FROM `users` WHERE `identifier` = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1].firstname ~= nil then
			local data = {
				identifier	= result[1].identifier,
				firstname	= result[1].firstname,
				lastname	= result[1].lastname,
				dateofbirth	= result[1].dateofbirth,
				sex			= result[1].sex
			}

			callback(data)
		else
			local data = {
				identifier	= '',
				firstname	= '',
				lastname	= '',
				dateofbirth	= '',
				sex			= ''
			}

			callback(data)
		end
	end)
end
end

function setIdentity(identifier, data, callback)
		if Config.useheight == true and Config.ifusemysqldatabase == true then
		MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
			['@identifier']		= identifier,
			['@firstname']		= data.firstname,
			['@lastname']		= data.lastname,
			['@dateofbirth']	= data.dateofbirth,
			['@sex']			= data.sex,
			['@height']			= data.height
		}, function(rowsChanged)
			if callback then
				callback(true)
			end
		end)
	else
		MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex WHERE identifier = @identifier', {
			['@identifier']		= identifier,
			['@firstname']		= data.firstname,
			['@lastname']		= data.lastname,
			['@dateofbirth']	= data.dateofbirth,
			['@sex']			= data.sex
		}, function(rowsChanged)
			if callback then
				callback(true)
			end
		end)
	end
end

function updateIdentity(playerId, data, callback)
		local xPlayer = ESX.GetPlayerFromId(playerId)

	if Config.useheight == true and Config.ifusemysqldatabase == true then
		MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
			['@identifier']		= xPlayer.identifier,
			['@firstname']		= data.firstname,
			['@lastname']		= data.lastname,
			['@dateofbirth']	= data.dateofbirth,
			['@sex']			= data.sex,
			['@height']			= data.height
		}, function(rowsChanged)
			if callback then
				TriggerEvent('esx_identity:characterUpdated', playerId, data)
				callback(true)
			end
		end)
	else
		MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex WHERE identifier = @identifier', {
			['@identifier']		= xPlayer.identifier,
			['@firstname']		= data.firstname,
			['@lastname']		= data.lastname,
			['@dateofbirth']	= data.dateofbirth,
			['@sex']			= data.sex
		}, function(rowsChanged)
			if callback then
				TriggerEvent('esx_identity:characterUpdated', playerId, data)
				callback(true)
			end
		end)

	end
end

function deleteIdentity(source)
if Config.useheight == true and Config.ifusemysqldatabase == true then
		local xPlayer = ESX.GetPlayerFromId(source)
		MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
			['@identifier']		= xPlayer.identifier,
			['@firstname']		= '',
			['@lastname']		= '',
			['@dateofbirth']	= '',
			['@sex']			= '',
			['@height']			= '',
		})
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex WHERE identifier = @identifier', {
			['@identifier']		= xPlayer.identifier,
			['@firstname']		= '',
			['@lastname']		= '',
			['@dateofbirth']	= '',
			['@sex']			= '',
		})
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
			xPlayer.showNotification('failed to set your character, try again later or contact the server admin!')
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

















AddEventHandler('esx_identity:characterUpdated', function(playerId, data)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if xPlayer then
		xPlayer.setName(('%s %s'):format(data.firstname, data.lastname))
		xPlayer.set('firstName', data.firstname)
		xPlayer.set('lastName', data.lastname)
		xPlayer.set('dateofbirth', data.dateofbirth)
		xPlayer.set('sex', data.sex)
		xPlayer.set('height', data.height)
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