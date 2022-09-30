--math.randomseed(os.time())
local missionStarted = false
local missionCooldown = false

local npcTable = {}

local spawnovano = false
local missionCar = {}
local lastState = nil
local lastArgs = nil


ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function debugPrint(text)
	if Config.Debug.Print then print(text) end
end

local lesterNPCHash = nil

function spawnLester(location)
    if location == "factory" then  
        lesterNPCHash = CreatePed(2, GetHashKey(Config.LesterNPCModel), Config.LesterNPCCoords.Factory, true, true)
    elseif location == "garage" then 
        lesterNPCHash = CreatePed(2, GetHashKey(Config.LesterNPCModel), Config.LesterNPCCoords.Garage, true, true)
    end
    FreezeEntityPosition(lesterNPCHash, true)
end

function deleteLester ()
    lesterNPCHash = DeleteEntity(lesterNPCHash)
end

spawnLester("factory")

ESX.RegisterUsableItem("lestercoin", function(source)
    TriggerClientEvent("revolucija_npcmisije:startMission", source)
end)

ESX.RegisterServerCallback('revolucija_npcmisije:proveriDostupnostMisije', function(src, cb)
    debugPrint("test")
    if  missionStarted == false and missionCooldown == false then 
        debugPrint("da")
        cb(true)
    else
        debugPrint("ne")
        cb(false)
    end
end)

ESX.RegisterServerCallback('revolucija_npcmisije:getPlayerItemCount', function(src, cb, item)
    local xPlayer = ESX.GetPlayerFromId(src)
    cb(xPlayer.getInventoryItem(item)["count"])
end)

ESX.RegisterServerCallback('revolucija_npcmisije:getPlayerJob', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    debugPrint(json.encode(xPlayer.getJob()))
    cb(xPlayer.getJob().name)
end)


function spawnPed(pedName, coords, heading, isNetwork, bScriptHostPed) 
    local pedModelHash = GetHashKey(pedName)
    
    local npcPedModel = CreatePed(2, pedModelHash, coords, heading, isNetwork, bScriptHostPed)
    return npcPedModel
end

function randomPed()
    --math.randomseed(os.time())
    math.random()
    local size = #Config.PedModels
    debugPrint(size)
    local id = math.random(size)
    debugPrint(id)
    local ped = Config.PedModels[id]
    debugPrint(ped)
	return ped
end

ESX.RegisterServerCallback("revolucija_npcmisije:spawnMissionNPC", function(src, cb)
    local args = {}
    for k, v in pairs(Config.PedSpawns) do
		--local spawnChance = Config.SpawnChance
		--if v.spawnChance then spawnChance = v.spawnChance end
        --local random = math.random(0, 100)
        --debugPrint("random  " .. random )
        ----math.randomseed(os.time())
		--if random <= spawnChance then
		v.ped = spawnPed(randomPed(), v.coords, v.rot, true, true)
        while not DoesEntityExist(v.ped) do 
            Wait(10)
        end
        debugPrint("before converting entitiy to network id:")
        debugPrint(v.ped)
        v.ped = NetworkGetNetworkIdFromEntity(v.ped)
        debugPrint("after converting entitiy to network id:")
        debugPrint(v.ped)
        table.insert(args,v)
        --end 
    end
    debugPrint("args encoded:")
    debugPrint(json.encode(args))
    cb(args)
end)




function spawnanje()
    npcTable.spawned = "spawnanje"
    missionCar.spawned = "spawnanje"

    CreateThread(function()
        Wait(10 * 1000)
        if npcTable.spawned == "spawnanje" and missionCar.spawned == "spawnanje" then 
            npcTable.spawned = false 
            missionCar.spawned = false
        end
    end)
    
    
end

ESX.RegisterServerCallback('revolucija_npcmisije:checkSpawn', function(src, cb)
    Wait(math.random(500, 1000))
    if npcTable.spawned == true and missionCar.spawned == true then 
        debugPrint("da")
        cb(true)
    else
        spawnanje()
        cb(false)
    end
end)




function cooldown()
    CreateThread(function()
        missionCooldown = true
        FreezeEntityPosition(lesterNPCHash, false)
        TaskGoToCoordAnyMeans(lesterNPCHash, 1275.5891113281, -1710.25, 54.771450042725, 5.0, 0, false, 786603, 0.0)
        Wait(Config.CooldownDuration)
        missionCooldown = false
        DeletePed(lesterNPCHash)
        spawnLester("factory")
    end)
end


ESX.RegisterServerCallback('revolucija_npcmisije:getTime', function(src, cb)
    cb(os.time())
end)

ESX.RegisterServerCallback('revolucija_npcmisije:randomTruck', function(src, cb)
    --math.randomseed(os.time())
    cb(Config.CarSpawns[math.random(1,4)])
end)

function randomBool()

    --math.randomseed(os.time())
    if Config.Debug.RandomBoolAlwaysTrue then return true
	elseif math.random() > 0.5 then
		return true
	else 
		return false 
	end
	
end

function missionEnd(args)
    missionStarted = false
    debugPrint(source)
    if args then 
        local xPlayer = ESX.GetPlayerFromId(source)
        debugPrint(xPlayer)
        xPlayer.addInventoryItem(Config.RewardItem, math.random(Config.RewardMinMax.x, Config.RewardMinMax.y))
    end
    cooldown()
    print("npcTable:")
    print(json.encode(npcTable))
    npcTable = {}
    lastState = nil
end


RegisterServerEvent('revolucija_npcmisije:syncToServer') 
AddEventHandler('revolucija_npcmisije:syncToServer', function(state, toAllClients, args) 
    if state == "pokreniMisiju" then
        missionStarted = source
    elseif state == "spawnovano" then 
        debugPrint(state)
        npcTable = args[1]
        print("npcTable posle spawnovano:")
        print(json.encode(npcTable))
        spawnovano = true
        lastState = state
        lastArgs = args
        args = {}
        deleteLester()
        spawnLester("garage")
    elseif state == "dajKljuceve" then 
        if source == missionStarted then 
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.addInventoryItem("humanekey", 1)
        end 
    elseif state == "uzmiItem" then
        if source == missionStarted then  
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.removeInventoryItem(args, 1)
        end
    elseif state == "playerSpawn" then
        state = lastState 
        args = lastArgs
        debugPrint(source)
        debugPrint(state)
        debugPrint(args)
        TriggerClientEvent("revolucija_npcmisije:syncToAllClients", source, state, args)
        
    elseif state == "zavrsiMisiju" then
        debugPrint("zavrsi misiju")
        if source == missionStarted then 
            missionEnd(args)
        end
    end

    
    if toAllClients then TriggerClientEvent("revolucija_npcmisije:syncToAllClients", -1, state, args) end
end)


AddEventHandler('playerDropped', function(reason)
    if source == missionStarted then 
        missionEnd(false)
        debugPrint("ugasena misija")
    end
end)
  
  
