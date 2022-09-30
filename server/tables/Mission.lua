Mission = {

    Create = function(missionName, source) 
        local instance = {
            cooldown = false,
            name = missionName or nil, -- ime aktivne misije
            starterID = source or nil, -- id klijenta koji je pokreno misiju
            stage = 0, -- etapa misije
            blipID = nil,
            locations = {
                hack = {
                    Pos = {
                        x = nil, 
                        y = nil, 
                        z = nil, 
                    },
                    Size = {
                        x = nil,
                        y = nil,
                        z = nil 
                    },
                    Color = {
                        r = nil,
                        g = nil,
                        b = nil 
                    },
                    Type = nil,
                    name = nil, 
                },
                
                finish = {
                    Pos = {
                        x = nil, 
                        y = nil, 
                        z = nil, 
                    },
                    Size = {
                        x = nil,
                        y = nil,
                        z = nil 
                    },
                    Color = {
                        r = nil,
                        g = nil,
                        b = nil 
                    },
                    Type = nil,
                    name = nil,
                }
            },
        
            peds = {}, --niz idjeva od pedova
            carID = 0, -- id kamiona

            tookKey = false,
            shownNotif = false,
            hackAttempts = 0,

            makeLocations = function(self)
                self.locations.hack =  Config[self.name].Locations.Hack[math.random(1, #Config[self.name].Locations.Hack)]
                self.locations.hack.name = "hack"
                self.locations.finish =  Config[self.name].Locations.Finish[math.random(1, #Config[self.name].Locations.Finish)]
                self.locations.finish.name = "finish"
            end,

            spawnPeds = function(self)
               -- CreateThread(function() 
                    for k, v in pairs(Config[self.name].PedSpawns) do
                        v.pedID = spawnPed(randomPed(self.name), v.coords, v.rot, true, true)
                        --while not DoesEntityExist(v.ped) do 
                           -- Wait(10)
                       -- end
                        debugPrint("before converting entitiy to network id:")
                        debugPrint(v.pedID)
                        v.pedID = NetworkGetNetworkIdFromEntity(v.pedID)
                        debugPrint("after converting entitiy to network id:")
                        debugPrint(v.pedID)
                        table.insert(self.peds,v)
                        --end 
                    end
                    
                --end)
                
            end,

            spawnCar = function(self) 
                local car = Config[self.name].CarSpawns[math.random(#Config[self.name].CarSpawns)]
                --self.carID = Citizen.InvokeNative(GetHashKey('CREATE_AUTOMOBILE'), Config[self.name].CarModel, car.coords, car.rotation)
                self.carID = CreateVehicle(GetHashKey(Config[self.name].CarModel), car.coords, car.rotation, true, true)
                while not DoesEntityExist(self.carID) do 
                    Wait(10)
                end
                print("helth: " .. GetEntityHealth(self.carID))
                self.carID = NetworkGetNetworkIdFromEntity(self.carID)

                print("entity: " .. NetworkGetEntityFromNetworkId(self.carID))
            end,

            syncToClients = function(self, id, state) 
                if not id then id = -1 end
                if not state then state = "regularSync" end 
                TriggerClientEvent("revolucija_misije:syncTableToClients", id, state, self)
            end,

            syncToServer = function(self, toAll, state)
                print(json.encode(self)) 
                if not state then state = "regularSync" end
                TriggerServerEvent("revolucija_misije:syncTableToClients", toAll, state, self)
            end,
            
            netIDtoEntity = function(self)
                for k, v in pairs(self.peds) do
                    v.pedID = NetworkGetEntityFromNetworkId(v.pedID)
                    DeleteEntity(v.pedID)
                end
                self.carID = NetworkGetEntityFromNetworkId(self.carID)
                print(self.carID)
                
            end,

            despawn = function(self)
                self:netIDtoEntity()
                for k, v in pairs(self.peds) do
                    DeleteEntity(v.pedID)
                end
                DeleteEntity(self.carID)
            end,

            cooldown = function(self) 
                self.name = nil 
                self.cooldown = true
                self:syncToClients(-1, "missionEnd")
                Wait(Config.CooldownDuration)
                self.cooldown = false
            end,
        
        }
        return instance
    end
}
