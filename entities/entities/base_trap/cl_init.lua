include("shared.lua")

function ENT:Initialize()
    -- Grab the mesh
    local meshTable = self:BuildMesh()

    -- Create a drawable version of the mesh
    self.mesh = Mesh()
    self.mesh:BuildFromTriangles(meshTable)

    self:SetRenderBounds(Vector(0,0,0), Vector(self.width, self.length, self.height))

    -- Init collisions
    self:PhysicsInit(SOLID_CUSTOM)
    self:PhysicsFromMesh(meshTable, true)
    self:EnableCustomCollisions(true)
    self:SetSolid(SOLID_VPHYSICS)

    -- Stop it from moving
    self:GetPhysicsObject():EnableMotion(false)
    self:SetMoveType(MOVETYPE_NONE)

    -- Build draw matrix
    self.matrix = Matrix();
    matrix:Translate(self:GetPos());
    matrix:Rotate(self:GetAngles());
end

local meshMaterial = Material("staircase/tester1")

function ENT:Draw( )
    local matrix = Matrix();
    matrix:Translate(self:GetPos());
    matrix:Rotate(self:GetAngles());

    render.SetMaterial(meshMaterial);

    cam.PushModelMatrix(matrix);
        self.mesh:Draw()
    cam.PopModelMatrix();
end
