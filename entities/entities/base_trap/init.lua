AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("cl_init.lua")

function ENT:Initialize()
    -- Build the mesh
    self:BuildMesh()

    -- Init collisions
    self:PhysicsInit(SOLID_CUSTOM)
    self:PhysicsFromMesh(self.meshTable, true)
    self:EnableCustomCollisions(true)
    self:SetSolid(SOLID_VPHYSICS)

    -- Stop it from moving
    self:GetPhysicsObject():EnableMotion(false)
    self:SetMoveType(MOVETYPE_NONE)
end