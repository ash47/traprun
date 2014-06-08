function GM:InitPostEntity()
    local refPos = ents.FindByName("tr_marker")[1]
    local spawnPos = Vector(0, 0, 0)
    if refPos then
        spawnPos = refPos:GetPos()
    else
        print("Failed to find the reference position! Using (0, 0, 0)")
    end

    -- Create the physics handlers
    for xx=1,GetxPhys() do
        for yy=1,GetyPhys() do
            local phys = ents.Create("ent_world_collisions")
            phys:SetPos(spawnPos)
            phys:Spawn()

            -- Store it
            StorePhysCol(xx, yy, phys)
        end
    end

    -- Spawn the world gen
    local worldGen = ents.Create("ent_world_gen")
    worldGen:SetPos(spawnPos)
    worldGen:Spawn()
    StoreWorldGen(worldGen)

    -- Get info needed to generate death zone
    local ts = GetTileSize()
    local xTiles = GetxTiles()
    local yTiles = GetyTiles()


    -- Add the death zone to the bottom of the map
    local deathZone = ents.Create("ent_generic_trigger")
    deathZone:SetPos(spawnPos)
    deathZone:Spawn()
    deathZone:SetBounds(Vector(0, 0, -4*ts), Vector(xTiles*ts, yTiles*ts, -3*ts))

    -- Make it kill players
    function deathZone:StartTouch(ent)
        if IsValid(ent) and ent:IsPlayer() then
            ent:Kill()
        end
    end

    -- Build the world
    BuildMap()
end

net.Receive("mapEnts", function(len, ply)
    -- Send this player the map entities
    SendMapEnts(ply)
end)