function GM:PlayerInitialSpawn(ply)
    -- Disable flashlight
    ply:AllowFlashlight(true)

    -- Set Model
    ply:SetModel("models/player/Group01/male_03.mdl")
end

function GM:PlayerSpawn(ply)
    -- Reset HP and Armor
    ply:SetHealth(ply:GetMaxHealth())
    ply:SetArmor(0)

    -- Remove any weapons
    ply:StripWeapons()
    ply:StripAmmo()

    -- Fix move speed
    ply:SetWalkSpeed(190)
    ply:SetRunSpeed(320)
end
