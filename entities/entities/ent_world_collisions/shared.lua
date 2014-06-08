AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()
    self:SetNoDraw(true)

    -- Stop movement
    self:SetMoveType(MOVETYPE_NONE)
end

function ENT:ApplyMesh(mesh)
    -- Init collisions
    self:PhysicsInit(SOLID_CUSTOM)
    self:PhysicsFromMesh(mesh or {}, true)
    self:EnableCustomCollisions(true)
    self:SetSolid(SOLID_VPHYSICS)

    -- Stop it from moving
    self:SetMoveType(MOVETYPE_NONE)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end
end