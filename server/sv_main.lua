ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local activeMission = {}


ESX.RegisterUsableItem("lestercoin", function(source)
    if not activeMission.cooldown and not activeMission.name then
        local xPlayer = ESX.GetPlayerFromId(source) 
        xPlayer.removeInventoryItem("lestercoin", 1)
        activeMission = Mission.Create("HumaneLabs", source)
        activeMission:makeLocations()
        activeMission:spawnPeds()
        activeMission:spawnCar()
        activeMission:syncToClients(-1, "spawned")
        print(json.encode(activeMission.locations))
        print(json.encode(activeMission.peds))
        print(activeMission.carID)
    end
end)

ESX.RegisterUsableItem("humanekey", function(source) 
    TriggerClientEvent("revolucija_misije:UseCarKey", source)
end)

RegisterCommand("despawn", function()
    activeMission:despawn() 
    activeMission:cooldown() 
    activeMission = {}
end, false)

RegisterServerEvent('revolucija_misije:syncTableToServer')
AddEventHandler('revolucija_npcmisije:syncTableToServer', function(toAll, state, table) 
    activeMission = table 
    activeMission:netIDtoEntity()
    if toall then activeMission:syncToClients() end
end)

RegisterServerEvent('revolucija_misije:syncToServer') 
AddEventHandler('revolucija_misije:syncToServer', function(state, args) 
    if source == activeMission.starterID then
        local xPlayer = ESX.GetPlayerFromId(source)
        if state == "giveKey" then 
            xPlayer.addInventoryItem("humanekey", 1)
        elseif state == "takeKey" then
            xPlayer.removeInventoryItem("humanekey", 1)        
        elseif state == "endMission" then
            debugPrint("zavrsi misiju")
            if args then xPlayer.addInventoryItem(Config[activeMission.name].RewardItem, math.random(Config[activeMission.name].RewardMinMax.x, Config[activeMission.name].RewardMinMax.y)) end
            activeMission:despawn() 
            activeMission:cooldown() 
            activeMission = {}
        end
    end

    
    
end)

ESX.RegisterServerCallback('revolucija_misije:getPlayerJob', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    debugPrint(json.encode(xPlayer.getJob()))
    cb(xPlayer.getJob().name)
end)

ESX.RegisterServerCallback('revolucija_misije:getActiveMission', function(src,cb)
    cb(activeMission)
end)


AddEventHandler('playerDropped', function(reason)
    if source == activeMission.starterID then 
        activeMission:despawn() 
        activeMission:cooldown() 
        activeMission = {}
    end
end)








