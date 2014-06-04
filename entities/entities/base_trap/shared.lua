ENT.Type        = "anim"
ENT.Base        = "base_anim"
ENT.PrintName   = "Base Trap"
ENT.Author      = "Ash47"
ENT.Contact     = "dont"

local ts = 4
local xx = 64*4
local yy = 64*100
local zz = 64*4
local o = 20

local function Vertex( pos, u, v, normal )
    return { pos = pos, u = u, v = v, normal = normal }
end

ENT.MeshTable = {
    --Vertex(Vector(0, 0, 0), 0, 0),
    --Vertex(Vector(w, 0, 0), ts, 0),
    --Vertex(Vector(w, l, 0), ts, 0),

    -- Bottom
    Vertex(Vector(0, 0, o), 0, 0),
    Vertex(Vector(0, yy, o), 0, ts),
    Vertex(Vector(xx, 0, o), ts, 0),

    Vertex(Vector(xx, yy, o), ts, ts),
    Vertex(Vector(xx, 0, o), ts, 0),
    Vertex(Vector(0, yy, o), 0, ts),

    -- Left
    Vertex(Vector(0, 0, o), 0, 0),
    Vertex(Vector(0, yy, o+zz), ts, ts),
    Vertex(Vector(0, yy, o), ts, 0),

    Vertex(Vector(0, 0, o), 0, 0),
    Vertex(Vector(0, 0, o+zz), 0, ts),
    Vertex(Vector(0, yy, o+zz), ts, ts),

    -- Right
    Vertex(Vector(xx, 0, o), 0, 0),
    Vertex(Vector(xx, yy, o), ts, 0),
    Vertex(Vector(xx, yy, o+zz), ts, ts),

    Vertex(Vector(xx, 0, o), 0, 0),
    Vertex(Vector(xx, yy, o+zz), ts, ts),
    Vertex(Vector(xx, 0, o+zz), 0, ts),

    -- Roof
    Vertex(Vector(0, 0, o+zz), 0, 0),
    Vertex(Vector(xx, 0, o+zz), ts, 0),
    Vertex(Vector(0, yy, o+zz), 0, ts),

    Vertex(Vector(xx, yy, o+zz), ts, ts),
    Vertex(Vector(0, yy, o+zz), 0, ts),
    Vertex(Vector(xx, 0, o+zz), ts, 0),


    --Vertex(Vector(size, size, height), texturescale, texturescale ),
    --Vertex(Vector(size, -size, height), texturescale, 0 ),
    --Vertex(Vector(-size, -size, height), 0, 0 ),
    --Vertex(Vector(-size, size, height), 0, texturescale ),
    --Vertex(Vector(size, size, height), texturescale, texturescale ),
    --Vertex(Vector(-size, -size, height), 0, 0 )
}