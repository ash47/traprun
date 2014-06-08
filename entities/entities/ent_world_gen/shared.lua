ENT.Type        = "anim"
ENT.Base        = "base_anim"

-- Grabs all the traps and builds a mesh out of them
function ENT:BuildMap()
    -- Will store our renderable meshes
    local renderMeshes = {}

    -- Reset out physics mesh
    self.physicsMesh = {}

    local tileSize = GetTileSize()

    for xx=1,GetxTiles() do
        for yy=1,GetyTiles() do
            -- Grab a cell
            local cell = GetMapCell(xx, yy)
            if cell then
                -- Check if it has a trap in it
                if cell.trapId ~= nil then
                    -- Grab this trap
                    local trap = GetTrap(cell.trapId)
                    local rot = cell.rot

                    -- Check if it has a mesh
                    if trap and trap.mesh then
                        -- Loop over all sections of this mesh
                        for k,v in pairs(trap.mesh) do
                            -- Workout the offsets
                            local o = Vector((xx-1)*tileSize, (yy-1)*tileSize, 0)

                            -- Build rendereable mesh
                            if CLIENT then
                                -- Ensure we have an instance for this mesh
                                renderMeshes[k] = renderMeshes[k] or {}
                            end

                            -- Build meshes
                            for kk, vv in pairs(v) do
                                for kkk, vvv in pairs(vv) do
                                    -- Make a copy of the vertex
                                    local vert = table.Copy(vvv)

                                    local ang = Angle(0, rot, 0)

                                    -- Apply rotation and offset
                                    vert.pos = vert.pos:RotateAbout(ang, Vector(trap.xSize/2*tileSize, trap.ySize/2*tileSize, 0)) + o

                                    -- If it has a normal, rotate it
                                    if vert.normal then
                                        local newNorm = Vector(vert.normal.x, vert.normal.y, vert.normal.z)
                                        newNorm:Rotate(ang)
                                        vert.normal = newNorm
                                    end

                                    -- Add to our renderable mesh
                                    if CLIENT then
                                        table.insert(renderMeshes[k], vert)
                                    end

                                    -- Check if we need physics on this part of the trap
                                    if not trap.nophysics or not trap.nophysics[k] then
                                        -- Add to our physics mesh
                                        table.insert(self.physicsMesh, vert)
                                    end
                                end
                            end

                            -- Remove duplicate triangles from physics mesh
                        end
                    end
                end
            end
        end
    end

    -- Build the renderable meshes
    if CLIENT then
        -- Reset our rendereables
        self.renderMeshes = {}

        for k,v in pairs(renderMeshes) do
            -- Create the meshes
            self.renderMeshes[k] = Mesh()
            self.renderMeshes[k]:BuildFromTriangles(v)
        end
    end

    -- Init collisions
    self:PhysicsInit(SOLID_CUSTOM)
    self:PhysicsFromMesh(self.physicsMesh, true)
    self:EnableCustomCollisions(true)
    self:SetSolid(SOLID_VPHYSICS)

    -- Stop it from moving
    self:SetMoveType(MOVETYPE_NONE)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end
end

--[[function ENT:BuildMesh()
    local tileCount = 4

    local xx = mapSettings.tileWidth * tileCount
    local yy = mapSettings.tileLength * tileCount
    local zz = mapSettings.tileHeight * tileCount

    if CLIENT then
        self.width = xx
        self.length = yy
        self.height = zz
    end

    -- Create a new mesh
    self:NewMesh()

    -- Bottom
    self:AddPlane(Vector(xx, yy, 0), Vector(0, yy, 0), Vector(0, 0, 0), Vector(xx, 0, 0))

    -- Left
    self:AddPlane(Vector(0, yy, 0), Vector(0, yy, zz), Vector(0, 0, zz), Vector(0, 0, 0))

    -- Right
    self:AddPlane(Vector(xx, yy, 0), Vector(xx, 0, 0), Vector(xx, 0, zz), Vector(xx, yy, zz))

    -- Top
    self:AddPlane(Vector(0, 0, zz), Vector(0, yy, zz), Vector(xx, yy, zz), Vector(xx, 0, zz))
end

-- Creates a new mesh
function ENT:NewMesh()
    self.meshTable = {}
end

-- Adds a plane to the mesh
function ENT:AddPlane(top_left, top_right, bottom_right, bottom_left)
    -- Fix tex coords

    table.insert(self.meshTable, Vertex(bottom_right, 1, 0))
    table.insert(self.meshTable, Vertex(top_right, 1, 1))
    table.insert(self.meshTable, Vertex(bottom_left, 0, 0))

    table.insert(self.meshTable, Vertex(top_right, 1, 1))
    table.insert(self.meshTable, Vertex(top_left, 0, 1))
    table.insert(self.meshTable, Vertex(bottom_left, 0, 0))
end]]

--[[function ENT:AddTrap(x, y, rot, trap)

end]]