ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

--Put this if you use a recent version of ESX LEGACY! --

-- ESX = exports["es_extended"]:getSharedObject() --

local isPurgeOn = false

RegisterServerEvent('H36vJdJsL9usz6s2')
AddEventHandler('H36vJdJsL9usz6s2',function(killer,ID)
    local zonaAsesino = estaEnZonaCaliente(ID)
    local zonaVictima = estaEnZonaCaliente(source)
    local estaLejos = estaLejosDeZonaCaliente(ID)

    if zonaAsesino and zonaVictima then
        --Envio de Kill al HUD
        TriggerClientEvent('hsMX8omVBJLQAU7Q', ID, GetPlayerName(source), Config.GiveMoney)
        
        --Dar dinero al asesiono
        local xTarget = ESX.GetPlayerFromId(ID)
        xTarget.addAccountMoney('bank', Config.GiveMoney)
    else
        if not estaLejos then
            if not zonaAsesino then
                TriggerClientEvent('showNotification', ID,"No has conseguido recompensa porque ~r~no estabas~w~ en ~o~Zona Caliente", nil)
            elseif not zonaVictima then
                TriggerClientEvent('showNotification', ID,"No has conseguido recompensa porque ~r~la víctima no estaba~w~ en ~o~Zona Caliente", nil)
            end
        end
    end
end)

RegisterCommand("startPurge", function(source, args, rawCommand)
    if (source > 0) then
        if hasPermission(source) then
            if not isPurgeOn then
                isPurgeOn = true
                TriggerClientEvent("startPurge", -1)
                syncPurge()
                TriggerClientEvent('showNotification', source,"~g~¡La purga ha empezado!", nil)
            else
                print("La purga ya está iniciada")
                TriggerClientEvent('showNotification', source,"~y~La purga ya está iniciada", nil)
            end
        else
            TriggerClientEvent('showNotification', source,"No tienes permisos para empezar La Purga", nil)
        end
    else
        if not isPurgeOn then
            isPurgeOn = true
            TriggerClientEvent("startPurge", -1)
            syncPurge()
            print("La purga se ha iniciado")
        else
            print("La purga ya está iniciada")
        end
    end
end, false)

RegisterCommand("stopPurge", function(source, args, rawCommand)
    if (source > 0) then
        if hasPermission(source) then
            if isPurgeOn then
                isPurgeOn = false
                TriggerClientEvent("stopPurge", -1)
                print("La purga ha sido parada")
                TriggerClientEvent('showNotification', source,"~r~La purga ha sido parada", nil)
            else
                print("La purga ya está parada")
                TriggerClientEvent('showNotification', source,"~r~La purga ya está parada", nil)
            end
        else
            TriggerClientEvent('showNotification', source,"No tienes permisos para parar La Purga", nil)
        end
    else
        if isPurgeOn then
            isPurgeOn = false
            TriggerClientEvent("stopPurge", -1)
            print("La purga ha sido parada")
        else
            print("La purga ya está parada")
        end
    end
end, false)

function syncPurge()
    Citizen.CreateThread(function() 
        while isPurgeOn do
            Citizen.Wait(5000)
            if isPurgeOn then
                TriggerClientEvent("startPurge", -1)
                if Config.Debug then
                    print("Enviando Sincronización de Purga a todos")
                end
            end
        end
        collectgarbage()
    end)
end

function hasPermission(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local group = xPlayer.getGroup()
    for k,v in ipairs(Config.adminpermission) do
        if v == group then
            return true
        end
    end return false
end

function estaEnZonaCaliente(src)
    local dataPedCoords = GetEntityCoords(GetPlayerPed(src))
    local pedCoords = vector3(dataPedCoords.x, dataPedCoords.y, dataPedCoords.z) 

    for k,v in ipairs(Config.ZonasCalientes) do
        if #(pedCoords.xy - v.coords.xy) < v.radius then
            return true
        end
    end

    return false
end


function estaLejosDeZonaCaliente(src)
    local dataPedCoords = GetEntityCoords(GetPlayerPed(src))
    local pedCoords = vector3(dataPedCoords.x, dataPedCoords.y, dataPedCoords.z) 

    for k,v in ipairs(Config.ZonasCalientes) do
        if #(pedCoords.xy - v.coords.xy) > Config.MaxDistanceToNotify then
            return true
        end
    end

    return false
end