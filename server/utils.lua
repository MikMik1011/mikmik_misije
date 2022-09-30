function debugPrint(text)
	if Config.Debug.Print then print(text) end
end

function spawnPed(pedName, coords, heading, isNetwork, bScriptHostPed) 
    local pedModelHash = GetHashKey(pedName)
    
    local npcPedModel = CreatePed(2, pedModelHash, coords, heading, isNetwork, bScriptHostPed)
    return npcPedModel
end

function randomPed(missionName)
    return Config[missionName].PedModels[math.random(#Config[missionName].PedModels)]
end

function randomBool()
    if Config.Debug.RandomBoolAlwaysTrue then return true
	elseif math.random() > 0.5 then
		return true
	else 
		return false 
	end	
end