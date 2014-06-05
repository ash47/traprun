AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("cl_init.lua")

function ENT:Initialize()
    -- Init collisions
    self:PhysicsInit(SOLID_CUSTOM)
    self:PhysicsFromMesh(self:BuildMesh(), true)
    self:EnableCustomCollisions(true)
    self:SetSolid(SOLID_VPHYSICS)

    -- Stop it from moving
    self:GetPhysicsObject():EnableMotion(false)
    self:SetMoveType(MOVETYPE_NONE)
end