function debugPrint(text)
	if Config.Debug.Print then print(text) end
end 

function randomGun(missionName)
	return Config[missionName].Weapons[math.random(1, #Config[missionName].Weapons)]
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

function randomBool()
	if Config.Debug.RandomBoolAlwaysTrue then return true
	elseif math.random() > 0.5 then
		return true
	else 
		return false 
	end
end

local serverID = nil 
function getServerID()
	if not serverID then serverID = GetPlayerServerId(PlayerId()) end 
	return serverID	
end 

function startAlarms()
	while not PrepareAlarm("FIB_05_BIOTECH_LAB_ALARMS") do
		Wait(10)
	end
	StartAlarm("FIB_05_BIOTECH_LAB_ALARMS", 0)
end

function createBlip(x, y, z, sprite, name)
	local blip = AddBlipForCoord(x, y, z) 
	SetBlipSprite(garazaBlip, sprite)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)
	return blip 
end