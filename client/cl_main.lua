ESX = nil

local activeMission = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(2)
	end
end)

function displayMissionText(noSync)
	activeMission.stage = activeMission.stage + 1
	missionText(Config[activeMission.name].ObjectiveMsgs[activeMission.stage], 10000)
	if not noSync then activeMission:syncToServer(true) end
end 

function handleActiveMission()
	debugPrint("spawnovano event")
	debugPrint(json.encode(activeMission.peds))
	while not isInRangeOfPoint(activeMission.peds[1].coords.x, activeMission.peds[1].coords.y, activeMission.peds[1].coords.z, 200) do 
		Wait(2000)
	end 
	for k, v in pairs(activeMission.peds) do
		debugPrint("network id passed from server:")
		debugPrint(v.pedID)
		while not DoesEntityExist(NetToPed(v.pedID)) do 
			Wait(10)
		end
		activeMission.peds[k].pedID = NetToPed(v.pedID)
	end
	while not DoesEntityExist(NetToVeh(activeMission.carID)) do 
		Wait(10)
	end
	activeMission.carID = NetToVeh(activeMission.carID)
	print(json.encode(activeMission))

	AddRelationshipGroup("missionNPC")

	startAlarms()

	ESX.TriggerServerCallback("revolucija_misije:getPlayerJob", function(job) 
		debugPrint(job)
		if job == "police" then
			SetRelationshipBetweenGroups(0, GetHashKey("missionNPC"), GetHashKey("PLAYER"))
			SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("missionNPC"))
			debugPrint("FRIEND")
		else 
			SetRelationshipBetweenGroups(5, GetHashKey("missionNPC"), GetHashKey("PLAYER"))
			SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("missionNPC"))
			debugPrint("ENEMY")
		end	
	end)
end 

function setPropertiesToPeds()
	for k, v in pairs(activeMission.peds) do
		while not DoesEntityExist(v.pedID) do Wait(10) end 
		SetPedRelationshipGroupHash(v.pedID, GetHashKey("missionNPC"))
		if v.weapon then 
			GiveWeaponToPed(v.pedID, GetHashKey(v.weapon), 999, false, false)
		else
			GiveWeaponToPed(v.pedID, GetHashKey(randomGun(activeMission.name)), 999, false, false)
		end
		SetPedCombatAbility(v.ped, math.random(0, 2))

		SetPedAccuracy(v.pedID, math.random(0, 100))
		SetPedAlertness(v.pedID, math.random(0,3))
		

		SetPedCanCowerInCover(v.pedID, randomBool())
		SetPedCanPeekInCover(v.pedID, randomBool())
		SetPedCanRagdoll(v.pedID, true)
		SetPedCanRagdollFromPlayerImpact(v.pedID, true)

		SetPedCombatAttributes(v.pedID, 0, randomBool())
		SetPedCombatAttributes(v.pedID, 1, randomBool())
		SetPedCombatAttributes(v.pedID, 2, randomBool())
		SetPedCombatAttributes(v.pedID, 3, randomBool())
		SetPedCombatAttributes(v.pedID, 5, randomBool())
		

		if v.movement then 
			SetPedCombatMovement(v.pedID, v.movement)
		else 
			SetPedCombatMovement(v.pedID, math.random(0, 3)) 
		end

		if v.range then 
			SetPedCombatRange(v.pedID, v.range)
		else 
			SetPedCombatRange(v.pedID, math.random(0, 2))
		end

		local health = nil
		if v.health then 
			health = v.health
		else 
			health = math.random(150, 200)
		end

		SetPedMaxHealth(v.pedID, health)
		SetEntityHealth(v.pedID, health)

		if v.armor then 
			SetPedArmour(v.pedID, v.armor)
		else 
			SetPedArmour(v.pedID, math.random(0, 100))
		end
		
		SetPedDropsWeaponsWhenDead(v.pedID, false)

		-- DA NE BEZE GOVNARI

		--SetBlockingOfNonTemporaryEvents(v.pedID, true)
		SetPedFleeAttributes(v.pedID, 0, false)
		SetPedCombatAttributes(v.pedID, 17, 1) 

	end 
end 
 

function startMarkerThreads()
	--in marker handler
	CreateThread(function()
		while activeMission.name do
			Wait(0)
	
			if CurrentAction then
				if not activeMission.shownNotif then 
					ESX.ShowNotification(CurrentActionMsg)
					activeMission.shownNotif = true
				end
				if IsControlJustReleased(0, 38) and activeMission.name then
	
					if CurrentAction == 'finish' then
						if(GetVehiclePedIsIn(PlayerPedId()) == activeMission.carID) then 
							endMission(true)
						else
							ESX.ShowNotification("Niste u vozilu iz Humane Labsa")
						end
					elseif CurrentAction == 'hack' then 
						if (not activeMission.tookKey) and activeMission.hackAttempts <= Config[activeMission.name].MaxHackAttempts then 
	  						TriggerEvent("utk_fingerprint:Start", 2, 3, 1.5, function(outcome)
								activeMission.hackAttempts = activeMission.hackAttempts + 1  
								if outcome then
									TriggerServerEvent("revolucija_misije:syncToServer", "giveKey")
									RemoveBlip(activeMission.blipID)
									activeMission.tookKey = true
									displayMissionText()
								else
									ESX.ShowNotification("Niste uspeli da ugasite zastitu!")
									RemoveBlip(activeMission.blipID)
									if activeMission.hackAttempts == Config[activeMission.name] then endMission(false, "maxhack") end
								end

							end)
							
						else
							ESX.ShowNotification("Vec ste uzeli kljuc!") 
						end
					end
					CurrentAction = nil
					activeMission.shownNotif = false
				end
			end
		end
	end)


	--draw marker handler

	CreateThread(function()
		while activeMission.name do
			Wait(5)
	
			local coords, letSleep = GetEntityCoords(PlayerPedId()), true
			local isInMarker  = false
			local currentZone = nil
	
			for k,v in pairs(activeMission.locations) do
				if v.Type ~= -1 and  #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end
	
				if(#(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x) then
					isInMarker  = true
					currentZone = v.name
				end
			end
	 
			if letSleep then
				Wait(1000)
			end
	
			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('revolucija_npcmisije:hasEnteredMarker', currentZone)
			end
	
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('revolucija_npcmisije:hasExitedMarker', LastZone)
			end
	
			
		end
	end)

	AddEventHandler('revolucija_npcmisije:hasEnteredMarker', function(zone)
		if zone == 'finish' then
			CurrentAction     = 'finish'
			CurrentActionMsg  = 'Pritisnite E da dostavite vozilo.'
			CurrentActionData = {}
			debugPrint(CurrentAction)
		end
		if zone == 'hack' then
			CurrentAction     = 'hack'
			CurrentActionMsg  = 'Pritisnite E da hakujete zastitu i uzmete kljuceve od auta.'
			CurrentActionData = {}
			debugPrint(CurrentAction)
		end
	end)
	
	AddEventHandler('revolucija_npcmisije:hasExitedMarker', function(zone)
		ESX.UI.Menu.CloseAll()
		CurrentAction = nil
	end)
end

function checkCarHealth() 
	CreateThread(function() -- nadgleda health kamiJona
		local health = nil
		while activeMission.name do 
			health = GetEntityHealth(activeMission.carID)
			--debugPrint(health)
			if health <= 0 then
				endMission(false, "truckdamaged")
				break 
			end 
			Wait(1000)
		end
	end)
end

RegisterNetEvent("revolucija_misije:UseCarKey")
AddEventHandler("revolucija_misije:UseCarKey", function() 
	local carDoorCoords = GetWorldPositionOfEntityBone(activeMission.carID, GetEntityBoneIndexByName(activeMission.carID, "door_dside_f"))
	if isInRangeOfPoint(carDoorCoords.x, carDoorCoords.y, carDoorCoords.z, 0.8) and activeMission.tookKey then
		local player = PlayerPedId()
		debugPrint("jeste")
		local animDictName = "missheistfbisetup1"
		RequestAnimDict(animDictName)
		while not HasAnimDictLoaded(animDictName) do 
			print("no loadedow")
			Wait(10) 
		end
		SetEntityHeading(player, math.abs(GetEntityHeading(activeMission.carID) - 90))
		TaskPlayAnim(player, animDictName, "unlock_loop_janitor", 2.0, -2.0, 5000, 1, 0, true, true, true)
		Wait(5000)
		TriggerServerEvent("revolucija_misije:syncToServer", "takeKey")

		SetVehicleDoorsLocked(activeMission.carID, 1)
		SetVehicleDoorsLockedForAllPlayers(activeMission.carID, false)
		displayMissionText()

		SetVehicleLights(activeMission.carID, 2)
		Wait(200)
		SetVehicleLights(activeMission.carID, 1)
		Wait(200)
		SetVehicleLights(activeMission.carID, 2)
		Wait(200)
		SetVehicleLights(activeMission.carID, 1)
		Wait(200)
		SetVehicleLights(activeMission.carID, 0)
		
		activeMission.blipID = createBlip(activeMission.locations.finish.Pos.x, activeMission.locations.finish.Pos.y, activeMission.locations.finish.Pos.z, 521, Config[activeMission.name].BlipMsgs.Finish)
		SetBlipRoute(garazaBlip, true)
		SetBlipRouteColour(activeMission.blipID, 43)
	end 
	
end)


RegisterNetEvent('revolucija_misije:syncTableToClients') 
AddEventHandler('revolucija_misije:syncTableToClients', function(state, args) 
	if state == "spawned" then
		activeMission = args
		if activeMission.starterID == getServerID() then
			activeMission.blipID = createBlip(activeMission.locations.hack.Pos.x, activeMission.locations.hack.Pos.y, activeMission.locations.hack.Pos.z, 521, Config[activeMission.name].BlipMsgs.Hack)
			SetBlipRoute(activeMission.blipID, true)
			SetBlipRouteColour(activeMission.blipID, 43)
			displayMissionText(true)
		end 

		handleActiveMission()

		

		if activeMission.starterID == getServerID() then
            -- setati ono pedovima

			setPropertiesToPeds()			

            -- zakljucati kamiJon
			SetVehicleDoorsLocked(activeMission.carID, 4)
			SetVehicleDoorsLockedForAllPlayers(activeMission.carID, true)
			debugPrint("zakljucan kamiJon")
			
			activeMission.syncToServer = function(self, toAll, state)
				--print(json.encode(self)) 
				if not state then state = "regularSync" end
				TriggerServerEvent("revolucija_misije:syncTableToClients", toAll, state, self)
			end

			checkCarHealth()
			displayMissionText()
			
			startMarkerThreads()

        end		
		
	elseif state == "missionEnd" then
		StopAlarm("FIB_05_BIOTECH_LAB_ALARMS", 1)
		activeMission.name = nil
		activeMission = {}
		print(activeMission.name)
	end
end)

function endMission(passed, reason)
	if activeMission.starterID == getServerID() then 
		activeMission.blipID = RemoveBlip(activeMission.blipID)
		TriggerServerEvent('revolucija_misije:syncToServer', "endMission", passed)
		if passed then 
			ESX.ShowNotification("Uspesno si zavrsio misiju, evo nagrade!")
			DeleteEntity(activeMission.carID)
		else
			local msg = nil 
			if reason == "cmd" then msg = "Prekinuo si misiju preko komande!"
			elseif reason == "truckdamaged" then msg = "Kamion je unisten!"
			elseif reason == "maxhack" then msg = "Previse neuspelih hakova!"
			elseif reason == "death" then msg = "Umro si!"
			else msg = "Usro si motku, Lesteru se ovo neće svideti!" end

			PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)
			ESX.Scaleform.ShowFreemodeMessage("~r~MISIJA NEUSPESNA", msg, 5)		
		end
		

	end 
end 

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function(playerData)
	ESX.TriggerServerCallback('revolucija_misije:getActiveMission', function(args) 
		activeMission = args
		if activeMission.name or not activeMission.coolDown then handleActiveMission(args) end
	end)
end)

RegisterCommand("prekinimisiju", function(source, args, rawCommand) 
	endMission(false, "cmd")
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	if activeMission.name then endMission(false, "death") end
end)