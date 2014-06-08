if(SERVER) then return end

-- Server is sending us the map entities
net.Receive("mapEnts", function(len)
    -- Store world gen
    StoreWorldGen(net.ReadEntity())

    -- Store all physics points
    for xx=1,GetxPhys() do
        for yy=1,GetyPhys() do
            StorePhysCol(xx, yy, net.ReadEntity())
        end
    end
end)

-- Server wants us to build
net.Receive("buildMap", function(len)
    -- Build the map
    BuildMap()
end)

function GM:InitPostEntity()
    -- Ask for the map entities
    SendMapEnts()
end
