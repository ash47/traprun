function GM:InitPostEntity()
    local refPos = ents.FindByName("tr_marker")[1]
    local spawnPos = Vector(0, 0, 0)
    if refPos then
        spawnPos = refPos:GetPos()
    else
        print("Failed to find the reference position! Using (0, 0, 0)")
    end

    -- Spawn the world gen
    local worldGen = ents.Create("ent_world_gen")
    worldGen:SetPos(spawnPos)
    worldGen:Spawn()

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
    function deathZone:Touch(ent)
        if IsValid(ent) and ent:IsPlayer() then
            ent:Kill()
        end
    end

    -- Spawn long corridor
    --[[for i=0,15 do
        for j=0,15 do
            if i == 0 and j == 0 then
                local test = ents.Create("trap_start")
                test:SetPos(refPos:GetPos()+Vector(64*4*j, 64*4*i, 0))
                test:Spawn()
            else
                local test = ents.Create("trap_hole")
                test:SetPos(refPos:GetPos()+Vector(64*4*j, 64*4*i, 0))
                test:Spawn()
            end
        end
    end]]
end
