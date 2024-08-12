local guiEnabled, hasIdentity, isDead = false, false, false
local myIdentity, myIdentifiers = {}, {}
local addItem = false

ESX = Config.BaseServerclient()


AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

RegisterNetEvent('esx_identity:showRegisterIdentity')
AddEventHandler('esx_identity:showRegisterIdentity', function()
	if not isDead then
        EnableGui(true)
    end
end)

function EnableGui(state)
    SetNuiFocus(state, state)
    guiEnabled = state
    if state then
        TriggerScreenblurFadeIn(100.0)
        SendNUIMessage({
            type = "show",
            min_char = Config.minect
        })
    else
        TriggerScreenblurFadeOut(200.0)
    end
end

RegisterNetEvent('esx_identity:identityCheck')
AddEventHandler('esx_identity:identityCheck', function(identityCheck)
	hasIdentity = identityCheck
end)

RegisterNetEvent('esx_identity:saveID')
AddEventHandler('esx_identity:saveID', function(data)
	myIdentifiers = data
end)

RegisterNUICallback('submit', function(data, cb)
	TriggerServerEvent('esx_identity:setIdentity', data, myIdentifiers)
	EnableGui(false)
	Citizen.Wait(500)
    local token = Config.tokentogetitem
	if not addItem then
		TriggerServerEvent('esx_identity:NewPlayer' , token)
		addItem = true
	end
end)