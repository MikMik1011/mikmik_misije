Mission = {
    name = nil, -- ime aktivne misije
    starterID = 0, -- id klijenta koji je pokreno misiju
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
        }
        
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
    }

    pedIDs = {} --niz idjeva od pedova
    carID = 0 -- id kamiona


    start = function(missionName)
        Mission.activeMission = missionName
        Mission.starterID = serverID()
        --syncuj sa sererom
    end

}