--[[
    VECTOR EXTENSIONS
]]
local meta = FindMetaTable("Vector")

-- Rotates a vector about a point
function meta:RotateAbout(ang, point)
    -- Translate so (0,0,0) = our point
    local newVec = Vector(self.x, self.y, self.z) - point

    -- Perform the rotation
    newVec:Rotate(ang)

    -- Translate back
    return newVec + point
end

