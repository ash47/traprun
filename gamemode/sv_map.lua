function GM:InitPostEntity()
    local refPos = ents.FindByName("tr_marker")[1]
    if not refPos then
        print("Failed to find the reference position!")
        return
    end

    -- Spawn long corridor
    for i=0,15 do
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
    end
end

-- Creates a server vertex
function Vertex(pos)
    return {pos = pos}
end