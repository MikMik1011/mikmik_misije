ESX = nil

local missionCar = {}

local missionStarted = false


local garazaBlip = nil

local hackAttempts = 0

local lokacije = {}


local npcTable = {}

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(2)
	end
end)

function debugPrint(text)
	if Config.Debug.Print then print(text) end
end 

if Config.Debug.Commands then 
	RegisterCommand("proveriVozilo", function(source, args, rawCommand) 
		if(GetVehiclePedIsIn(PlayerPedId()) == missionCar.id) then 
			ESX.ShowNotification("jeste")
		end
	end)
	
	RegisterCommand("krajmisije", function(source, args, rawCommand) 
		zavrsiMisiju(true)
	end)
	
end

RegisterCommand("prekinimisiju", function(source, args, rawCommand) 
	zavrsiMisiju(false, "cmd")
end)

RegisterNetEvent('revolucija_npcmisije:startMission') 
AddEventHandler('revolucija_npcmisije:startMission', function() 
	debugPrint("idemo nis")
	if isInRangeOfPoint(Config.LesterNPCCoords.Factory.x, Config.LesterNPCCoords.Factory.y, Config.LesterNPCCoords.Factory.z, 3) then 
		debugPrint("in range")
		ESX.TriggerServerCallback("revolucija_npcmisije:getPlayerItemCount", function(count) 
			debugPrint(count)
			if count >= 1 then 
				debugPrint("test")
				ESX.TriggerServerCallback("revolucija_npcmisije:proveriDostupnostMisije", function(vrati)
					debugPrint(vrati) 
					if vrati then 
						--TriggerServerEvent("revolucija_npcmisije:pokreniMisijuServer")
						TriggerServerEvent("revolucija_npcmisije:syncToServer", "pokreniMisiju")
						TriggerServerEvent("revolucija_npcmisije:syncToServer", "uzmiItem", false, "lestercoin")
						missionStarted = true
						debugPrint(missionStarted)
						CreateThread(function()
							while npcTable.spawned ~= true and missionCar.spawned ~= true and missionStarted do
								Wait(2000)
								debugPrint("wait")
								local playerPos = GetEntityCoords(PlayerPedId())
								local humaneLabsPos = vector3(3532.64453125, 3724.0441894531, 36.446399688721)
								local distanca = #(playerPos - humaneLabsPos)
								debugPrint(distanca)
								if distanca <= 150 then
									zapocniMisiju()
									break
								end
							end
						end)
						missionText("Idi do ~y~Humane Labs~w~-a.", 10000)

						ClearGpsMultiRoute()

						StartGpsMultiRoute(12, true, true)

						AddPointToGpsMultiRoute(3430.3698730469, 3763.7534179688, 30.832054138184)
						SetGpsMultiRouteRender(true)
						lokacije.kraj = Config.MarkerLokacije.Kraj[math.random(1, #Config.MarkerLokacije.Kraj)]
						lokacije.kraj.name = "dock"
						lokacije.kljuc = Config.MarkerLokacije.Kljuc[math.random(1, #Config.MarkerLokacije.Kljuc)]
						lokacije.kljuc.name = "kljucevi"

					else	
						ESX.ShowNotification("misija je pokrenuta vec!")
					end
				end)

			else
				ESX.ShowNotification("Nemate zlatan novcic da pokrenete misiju!")
			end
		end, 'lestercoin')
	end
end)	



function spawnPed(pedName, coords, heading, isNetwork, bScriptHostPed) 
    local pedModelHash = GetHashKey(pedName)

    RequestModel(pedModelHash)
    while not HasModelLoaded(pedModelHash) do
        Wait(1)
    end
    
    local npcPedModel = CreatePed(2, pedModelHash, coords, heading, isNetwork, bScriptHostPed)
    return npcPedModel
end

function randomPed()
	return Config.PedModels[math.random(1, #Config.PedModels)]
end

function randomGun()
	return Config.Weapons[math.random(1, #Config.Weapons)]
end

function isInRangeOfPoint(pointX, pointY, pointZ, range)
	local playerPos = GetEntityCoords(PlayerPedId())
	local distanca = #(playerPos - vector3(pointX, pointY, pointZ))
	if distanca <= range then return true 
	else return false end
end

function missionText(text, time)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(text)
	DrawSubtitleTimed(time, 1)
end

function spawnMissionNPC()
	
	AddRelationshipGroup("obezbedjenje")
	
	ESX.TriggerServerCallback("revolucija_npcmisije:spawnMissionNPC", function(args) 
		debugPrint("npc arg tabla")
		debugPrint(json.encode(args))
		for k, v in pairs(args) do
			debugPrint("network id passed from server:")
			debugPrint(v.ped)
			while not DoesEntityExist(NetToPed(v.ped)) do 
                Wait(10)
            end
			v.ped = NetToPed(v.ped) 
			debugPrint("entity converted from network id passed from server:")
			debugPrint(GetEntityCoords(v.ped))
			debugPrint(v.ped)
			debugPrint(json.encode(v))
			SetPedRelationshipGroupHash(v.ped, GetHashKey("obezbedjenje"))
			if v.weapon then 
				GiveWeaponToPed(v.ped, GetHashKey(v.weapon), 999, false, false)
			else
				GiveWeaponToPed(v.ped, GetHashKey(randomGun()), 999, false, false)
			end
			--SetPedCombatAbility(v, math.random(0, 2))

			SetPedAccuracy(v.ped, math.random(0, 100))
			SetPedAlertness(v.ped, math.random(0,3))
			

			SetPedCanCowerInCover(v.ped, randomBool())
			SetPedCanPeekInCover(v.ped, randomBool())
			SetPedCanRagdoll(v.ped, true)
			SetPedCanRagdollFromPlayerImpact(v.ped, true)

			SetPedCombatAttributes(v.ped, 0, randomBool())
			SetPedCombatAttributes(v.ped, 1, randomBool())
			SetPedCombatAttributes(v.ped, 2, randomBool())
			SetPedCombatAttributes(v.ped, 3, randomBool())
			SetPedCombatAttributes(v.ped, 5, randomBool())

			if v.movement then 
				SetPedCombatMovement(v.ped, v.movement)
			else 
				SetPedCombatMovement(v.ped, math.random(0, 3)) 
			end

			if v.range then 
				SetPedCombatRange(v.ped, v.range)
			else 
				SetPedCombatRange(v.ped, math.random(0, 2))
			end

			local health = nil
			if v.health then 
				health = v.health
			else 
				health = math.random(150, 200)
			end

			SetPedMaxHealth(v.ped, health)
			SetEntityHealth(v.ped, health)

			if v.armor then 
				SetPedArmour(v.ped, v.armor)
			else 
				SetPedArmour(v.ped, math.random(0, 100))
			end
			
			local dropChance = Config.DropChance
			if v.dropChance then dropChance = v.dropChance end 
			debugPrint("dropchance = " .. dropChance)
			if math.random(0, 100) <= dropChance then 
				SetPedDropsWeaponsWhenDead(v.ped, true)
				debugPrint("drop false")
			else 
				SetPedDropsWeaponsWhenDead(v.ped, false)
			end
			npctable = args 
		end 
		npcTable.spawned = true
		spawnMissionCar()
	end)
end

function spawnMissionCar() 
	vozilo = Config.CarSpawns[math.random(1,4)]
	ESX.Game.SpawnVehicle("boxville3", vozilo.coords, vozilo.rotation, function(vehicle)
		ESX.ShowNotification("spawnanao")
		SetVehicleDoorsLocked(vehicle, 4)
		SetVehicleDoorsLockedForAllPlayers(vehicle, true)
		missionCar.id = vehicle
		missionCar.coords = vozilo.coords
		debugPrint(missionCar.id)
		missionCar.spawned = true
		gledajCarHealth()
	end)	
end

function startAlarms()
	while not PrepareAlarm("FIB_05_BIOTECH_LAB_ALARMS") do
		Wait(0)
	end
	StartAlarm("FIB_05_BIOTECH_LAB_ALARMS", 0)
end

function zapocniMisiju() 
		debugPrint(vrati) 
		if not vrati then 
			spawnMissionNPC()
			missionText("~r~Obezbedjenje ~w~te je primetilo i upalilo alarm! Pronadji ~b~kljuc od vozila~w~!", 10000)
			local args = {}
			while not missionCar.spawned and npcTable.spawned do
				Wait(3)
			end
			table.insert(args, npcTable)
			table.insert(args, missionCar)
			debugPrint("args za server tablu:")
			debugPrint(json.encode(args))
			--TriggerServerEvent("revolucija_npcmisije:setujNPCTablu", npcTable)
			TriggerServerEvent("revolucija_npcmisije:syncToServer", "spawnovano", true, args)
			ClearGpsMultiRoute()
			startMarkerThreads()

		end

	
    
end


function zavrsiMisiju(stanje, razlog)
	TriggerServerEvent("revolucija_npcmisije:syncToServer", "zavrsiMisiju", true, stanje)
	if stanje then ESX.Game.DeleteVehicle(missionCar.id) end
	missionCar.spawned = false
	missionStarted = false
	npcTable = {}
	missionCar = {}
	lokacije = {}
	RemoveBlip(garazaBlip)
	garazaBlip = nil

	if stanje then ESX.ShowNotification("Uspesno si zavrsio misiju, evo nagrade!")
	else
		local msg = nil 
		if razlog == "cmd" then msg = "Prekinuo si misiju preko komande!"
		elseif razlog == "truckdamaged" then msg = "Kamion je unisten!"
		elseif razlog == "maxhack" then msg = "Previse neuspelih hakova!"
		elseif razlog == "death" then msg = "Umro si!"
		else msg = "Usro si motku, Lesteru se ovo neće svideti!" end

		PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)
		ESX.Scaleform.ShowFreemodeMessage("~r~MISIJA NEUSPESNA", msg, 5)
		
	end
end

function randomBool()

	if Config.Debug.RandomBoolAlwaysTrue then return true
	elseif math.random() > 0.5 then
		return true
	else 
		return false 
	end
	
end

function gledajCarHealth() 
	CreateThread(function() -- nadgleda health kamiJona
		local health = nil
		while missionStarted do 
			health = GetEntityHealth(missionCar.id)
			--debugPrint(health)
			if health == 0 then
				zavrsiMisiju(false, "truckdamaged")
				break 
			end 
			Wait(1000)
		end
	end)
end

function startCarThread()
	
	CreateThread(function()
		local unlockedCar = false
		local isInCar = false
		local wasInCar = false
		local count0pokazan = false 
		local count2pokazan = false
		while missionStarted and not unlockedCar do
			local playerPos = GetEntityCoords(PlayerPedId())
			local distanca = #(playerPos - missionCar.coords)
			debugPrint(distanca)
			if distanca <= 10 then
				ESX.TriggerServerCallback("revolucija_npcmisije:getPlayerItemCount", function(count)
					debugPrint("count: " .. count) 
					if count == 1 then 
						SetVehicleDoorsLocked(missionCar.id, 1)
						SetVehicleDoorsLockedForAllPlayers(missionCar.id, false)
						unlockedCar = true 
						missionText("Otkljucali ste ~b~vozilo~w~, sada sednite u njega!", 10000)
						TriggerServerEvent("revolucija_npcmisije:syncToServer", "uzmiItem", false, "humanekey")
						SetVehicleLights(missionCar.id, 2)
						Wait(200)
						SetVehicleLights(missionCar.id, 1)
						Wait(200)
						SetVehicleLights(missionCar.id, 2)
						Wait(200)
						SetVehicleLights(missionCar.id, 1)
						Wait(200)
						SetVehicleLights(missionCar.id, 0)
					elseif count < 1 then 
						if not count0pokazan then 
							ESX.ShowHelpNotification("Nemas kljuc pa se kamion ne moze otkljucati!") 
							count0pokazan = true 
						end
					elseif count > 1 then 
						if not count2pokazan then 
							ESX.ShowHelpNotification("Imas vise kljuceva pa se njihovi signali mesaju, te se kamion ne moze otkljucati!") 
							count2pokazan = true 
						end
					end
				end, "humanekey")
			end
			Wait(1000)
		end

		while missionStarted do
			isInCar = GetVehiclePedIsIn(PlayerPedId()) == missionCar.id 
			if isInCar ~= wasInCar then 
				wasInCar = isInCar
				if isInCar then 
					if not garazaBlip then 
						local blipPos = lokacije.kraj.Pos
						garazaBlip = AddBlipForCoord(blipPos.x, blipPos.y, blipPos.z) 
						SetBlipSprite(garazaBlip, 289)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Garaza za ostavljanje Humane kamiona") -- set garazaBlip's "name"
						EndTextCommandSetBlipName(garazaBlip) 
    					SetBlipRouteColour(garazaBlip,  43)
					end
					SetBlipRoute(garazaBlip, true)
					missionText("Idi na ~y~dockove ~w~i ostavi kamion u garazu.", 10000)
				else
					SetBlipRoute(garazaBlip, false) 
					if missionCar.spawned then missionText("Vrati se u ~b~vozilo~w~!", 10000) end
				end
			end
			Wait(1000)
		end
	end)
end


function startMarkerThreads()
	--in marker handler
	CreateThread(function()
		local tookKey = false
		local shownNotif = false
		while missionStarted do
			Wait(0)
	
			if CurrentAction then
				if not shownNotif then 
					ESX.ShowNotification(CurrentActionMsg)
					shownNotif = true
				end
				if IsControlJustReleased(0, 38) and missionStarted then
	
					if CurrentAction == 'dock' then
						if(GetVehiclePedIsIn(PlayerPedId()) == missionCar.id) then 
							zavrsiMisiju(true)
						else
							ESX.ShowNotification("Niste u vozilu iz Humane Labsa")
						end
					elseif CurrentAction == 'kljucevi' then 
						if not tookKey and hackAttempts <= Config.MaxHackAttempts then 
	  						TriggerEvent("ultra-voltlab", 45, function(success)
								hackAttempts = hackAttempts + 1  
								if success == 1 then
									TriggerServerEvent("revolucija_npcmisije:syncToServer", "dajKljuceve")
									missionText("Nasli ste ~b~kljuc od kamiona~w~, sada idite do njega i sam ce se otkljucati!", 10000)
									startCarThread()
									tookKey = true
								else
									ESX.ShowNotification("Niste uspeli da ugasite zastitu!")
									if hackAttempts == Config.MaxHackAttempts then zavrsiMisiju(false, "maxhack") end
								end

							end)
							
						else
							ESX.ShowNotification("Vec ste uzeli kljuc!") 
						end
					end
					CurrentAction = nil
					shownNotif = false
				end
			end
		end
	end)


	--draw marker handler

	CreateThread(function()
		while missionStarted do
			Wait(0)
	
			if missionStarted then
				local coords, letSleep = GetEntityCoords(PlayerPedId()), true
				local isInMarker  = false
				local currentZone = nil
	
				for k,v in pairs(lokacije) do
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
	
			else
				Wait(1000)
			end
		end
	end)


end


AddEventHandler('revolucija_npcmisije:hasEnteredMarker', function(zone)
	if zone == 'dock' then
        CurrentAction     = 'dock'
		CurrentActionMsg  = 'Pritisnite E da dostavite vozilo.'
		CurrentActionData = {}
	end
	if zone == 'kljucevi' then
        CurrentAction     = 'kljucevi'
		CurrentActionMsg  = 'Pritisnite E da hakujete zastitu i uzmete kljuceve od auta.'
		CurrentActionData = {}
	end
end)

AddEventHandler('revolucija_npcmisije:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)



RegisterNetEvent('revolucija_npcmisije:syncToAllClients') 
AddEventHandler('revolucija_npcmisije:syncToAllClients', function(state, args) 
	if state == "spawnovano" then
		debugPrint("spawnovano event")
		startAlarms()

		ESX.TriggerServerCallback("revolucija_npcmisije:getPlayerJob", function(job) 
			debugPrint(job)
			if job == "police" then
				SetRelationshipBetweenGroups(0, GetHashKey("obezbedjenje"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(0, GetHashKey("PLAYER"), GetHashKey("obezbedjenje"))
				debugPrint("prijatelji")
			else 
				SetRelationshipBetweenGroups(5, GetHashKey("obezbedjenje"), GetHashKey("PLAYER"))
				SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("obezbedjenje"))
				debugPrint("neprijatelji")
			end	
		end)
		
		
	elseif state == "zavrsiMisiju" then
		StopAlarm("FIB_05_BIOTECH_LAB_ALARMS", 1)
	end
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function(playerData)
	debugPrint("revived")
	TriggerServerEvent("revolucija_npcmisije:syncToServer", "playerSpawn", false, playerData)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	if missionStarted then zavrsiMisiju(false, "death") end
end)