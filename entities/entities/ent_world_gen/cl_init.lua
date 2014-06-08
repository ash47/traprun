include("shared.lua")

function ENT:Initialize()
    -- This will house all the meshes we need to render
    self.renderMeshes = {}

    local xTiles = GetxTiles()
    local yTiles = GetyTiles()
    local tileSize = GetTileSize()

    -- Make it visible
    self:SetRenderBounds(Vector(0, 0, -4*tileSize), Vector(xTiles*tileSize, yTiles*tileSize, 4*tileSize))

    -- Stop movement
    self:SetMoveType(MOVETYPE_NONE)
end

function ENT:UpdateMeshes(meshes)
    self.renderMeshes = meshes
end

local mats = {
    --def = Material("models/props_wasteland/wood_fence01a"),
    def = Material("traprun/wall"),
    floor = Material("traprun/floor"),
    roof = Material("traprun/roof"),
    spike = Material("traprun/spike")
}

function ENT:Draw()
    self:DrawModel()

    local matrix = Matrix()
    matrix:Translate(self:GetPos())
    matrix:Rotate(self:GetAngles())

    cam.PushModelMatrix(matrix)
        for k,v in pairs(self.renderMeshes) do
            render.SetMaterial(mats[k] or mats.def)
            v:Draw()
        end
    cam.PopModelMatrix()
end
