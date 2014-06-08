AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("cl_init.lua")

function ENT:Initialize()
    -- Set our model (needed to render mesh)
    self:SetModel("models/Gibs/HGIBS.mdl")

    -- Stop movement
    self:SetMoveType(MOVETYPE_NONE)
end
