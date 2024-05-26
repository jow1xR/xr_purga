local enabled = false
local playerSpawned = false

Citizen.CreateThread(function ()
    local playerPed = playerPedId()
    local weaponHash = GetHashKey('WEAPON_MICROSMG')

    if not HasPedGotWeapon(playerPed, weaponHash, false) then
        GiveWeaponToPed(player, weaponHash, 1000, false, true)
    end
end)

Citizen.CreateThread(function ()
    local playerPed = playerPedId()
    local weaponHash = GetHashKey('AMMO-45')

    if not HasPedGotWeapon(playerPed, weaponHash, false) then
        GiveWeaponToPed(player, weaponHash, 1000, false, true)
    end
end)

RegisterNetEvent('showNotification')
AddEventHandler('showNotification', function(text, origin)
    local playerPed = GetPlayerPed(-1) local ownID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(playerPed))
    if origin ~= ownID then
        ShowNotification(text)
    end
end)

AddEventHandler('playerSpawned', function()
    Citizen.CreateThread(function()
        Citizen.Wait(6000)
        playerSpawned = true
    end)    
end)

RegisterNetEvent('hsMX8omVBJLQAU7Q')
AddEventHandler('hsMX8omVBJLQAU7Q', function(nombre, dinero)
    SendNUIMessage({action = "kill", name = nombre, money = dinero})
end)

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(0,1)
end


RegisterNetEvent('startPurge')
AddEventHandler('startPurge', function()
    local playerPed = GetPlayerPed(-1) local ownID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(playerPed))
    if not enabled and playerSpawned then
        enabled = true
        purge()
        SendNUIMessage({action = "show"})
        SendNUIMessage({action = "eventStarted"})
    end
end)

RegisterNetEvent('stopPurge')
AddEventHandler('stopPurge', function()
    if enabled then
        enabled = false
        SendNUIMessage({action = "reset"})
    end
end)


function purge()
    Citizen.CreateThread(function()
        alreadyDead = false
        while true do
            if enabled then
                Citizen.Wait(100)
                local playerPed = GetPlayerPed(-1)
                if IsEntityDead(playerPed) and not alreadyDead then
                    killer = GetPedSourceOfDeath(playerPed) killername = false killerID = false
                    for _, player in ipairs(GetActivePlayers()) do
                        local ped = GetPlayerPed(player)
                        if killer == ped then
                            killername = GetPlayerName(player) killerID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
                        end	
                    end
                    if killername and killername ~= '**Invalid**' then
                        TriggerServerEvent('H36vJdJsL9usz6s2',killername,killerID)
                    end
                    alreadyDead = true
                end
                
                if not IsEntityDead(playerPed) then alreadyDead = false end
            else
                break
            end
        end
    end)
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        playerSpawned = true
    end
end)