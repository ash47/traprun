AddCSLuaFile()
ENT.Base = "base_trap"

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
    self:AddPlane(Vector(xx, yy/4, 0), Vector(0, yy/4, 0), Vector(0, 0, 0), Vector(xx, 0, 0))
    self:AddPlane(Vector(xx, yy, 0), Vector(0, yy, 0), Vector(0, yy*3/4, 0), Vector(xx, yy*3/4, 0))

    -- Left
    self:AddPlane(Vector(0, yy, -zz), Vector(0, yy, zz), Vector(0, 0, zz), Vector(0, 0, -zz))

    -- Right
    self:AddPlane(Vector(xx, yy, -zz), Vector(xx, 0, -zz), Vector(xx, 0, zz), Vector(xx, yy, zz))

    -- Top
    self:AddPlane(Vector(0, 0, zz), Vector(0, yy, zz), Vector(xx, yy, zz), Vector(xx, 0, zz))

    -- Front Hole Area
    self:AddPlane(Vector(0, yy*3/4, 0), Vector(0, yy*3/4, -zz), Vector(xx, yy*3/4, -zz), Vector(xx, yy*3/4, 0))

    -- Back Hole Area
    self:AddPlane(Vector(0, yy/4, 0), Vector(xx, yy/4, 0), Vector(xx, yy/4, -zz), Vector(0, yy/4, -zz))
end
