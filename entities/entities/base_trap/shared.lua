ENT.Type        = "anim"
ENT.Base        = "base_anim"
ENT.PrintName   = "Base Trap"
ENT.Author      = "Ash47"
ENT.Contact     = "dont"

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

    return {
        -- Bottom
        Vertex(Vector(0, 0, 0), 0, 0),
        Vertex(Vector(0, yy, 0), 0, tileCount),
        Vertex(Vector(xx, 0, 0), tileCount, 0),

        Vertex(Vector(xx, yy, 0), tileCount, tileCount),
        Vertex(Vector(xx, 0, 0), tileCount, 0),
        Vertex(Vector(0, yy, 0), 0, tileCount),

        -- Left
        Vertex(Vector(0, 0, 0), 0, 0),
        Vertex(Vector(0, yy, zz), tileCount, tileCount),
        Vertex(Vector(0, yy, 0), tileCount, 0),

        Vertex(Vector(0, 0, 0), 0, 0),
        Vertex(Vector(0, 0, zz), 0, tileCount),
        Vertex(Vector(0, yy, zz), tileCount, tileCount),

        -- Right
        Vertex(Vector(xx, 0, 0), 0, 0),
        Vertex(Vector(xx, yy, 0), tileCount, 0),
        Vertex(Vector(xx, yy, zz), tileCount, tileCount),

        Vertex(Vector(xx, 0, 0), 0, 0),
        Vertex(Vector(xx, yy, zz), tileCount, tileCount),
        Vertex(Vector(xx, 0, zz), 0, tileCount),

        -- Roof
        Vertex(Vector(0, 0, zz), 0, 0),
        Vertex(Vector(xx, 0, zz), tileCount, 0),
        Vertex(Vector(0, yy, zz), 0, tileCount),

        Vertex(Vector(xx, yy, zz), tileCount, tileCount),
        Vertex(Vector(0, yy, zz), 0, tileCount),
        Vertex(Vector(xx, 0, zz), tileCount, 0),
    }
end
