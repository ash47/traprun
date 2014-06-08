ENT.Base = "base_brush"
ENT.Type = "brush"

-- Updates the bounds of this collision box
function ENT:SetBounds(min, max)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionBounds(min, max)
    self:SetTrigger(true)
end
