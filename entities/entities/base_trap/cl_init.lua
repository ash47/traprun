include("shared.lua")

function ENT:Initialize()
    -- Grab the mesh
    self:BuildMesh()

    -- Create a drawable version of the mesh
    self.mesh = Mesh()
    self.mesh:BuildFromTriangles(self.meshTable)

    -- Calculate mins and maxs
    local mins = Vector(10000, 10000, 10000)
    local maxs = Vector(-10000, -10000, -10000)
    for k,v in pairs(self.meshTable) do
        local p = v.pos

        mins.x = math.min(mins.x, p.x)
        mins.y = math.min(mins.y, p.y)
        mins.z = math.min(mins.z, p.z)

        maxs.x = math.max(maxs.x, p.x)
        maxs.y = math.max(maxs.y, p.y)
        maxs.z = math.max(maxs.z, p.z)
    end

    self:SetRenderBounds(mins, maxs)

    -- Init collisions
    self:PhysicsInit(SOLID_CUSTOM)
    self:PhysicsFromMesh(self.meshTable, true)
    self:EnableCustomCollisions(true)
    self:SetSolid(SOLID_VPHYSICS)
end

local meshMaterial = Material("staircase/tester1")

function ENT:Draw( )
    local matrix = Matrix()
    matrix:Translate(self:GetPos())
    matrix:Rotate(self:GetAngles())

    render.SetMaterial(meshMaterial)

    cam.PushModelMatrix(matrix)
        self.mesh:Draw()
    cam.PopModelMatrix()
end
