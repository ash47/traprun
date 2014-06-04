AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("cl_init.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/PopCan01a.mdl")

    self:PhysicsInit(SOLID_CUSTOM)
    self:SetSolid(SOLID_VPHYSICS)

    self:PhysicsFromMesh(self.MeshTable, true)

    self:GetPhysicsObject():EnableMotion(false)
    self:SetMoveType(MOVETYPE_NONE)

    self:EnableCustomCollisions(true)
end