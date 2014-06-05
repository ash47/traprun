ENT.Type        = "anim"
ENT.Base        = "base_anim"

function ENT:BuildMesh()
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
end