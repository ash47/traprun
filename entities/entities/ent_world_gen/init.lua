AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("cl_init.lua")

function ENT:Initialize()
    -- Set our model (needed to render mesh)
    self:SetModel("models/Gibs/HGIBS.mdl")

    -- Build the map
    self:BuildMap()
end

--[[function ENT:UpdatePhysics()
    -- Build the mesh
    self:BuildMesh()

    -- Init collisions
    self:PhysicsInit(SOLID_CUSTOM)
    self:PhysicsFromMesh(self.meshTable, true)
    self:EnableCustomCollisions(true)
    self:SetSolid(SOLID_VPHYSICS)

    -- Stop it from moving
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end
end]]