function GM:PlayerInitialSpawn(ply)
    -- Disable flashlight
    ply:AllowFlashlight(true)
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
