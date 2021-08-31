local getBloodColor = FindMetaTable( "Entity" ).GetBloodColor
local isBulletDamage = FindMetaTable( "CTakeDamageInfo" ).IsBulletDamage

local util_Decal = util.Decal
local math_random = math.random
local rawget = rawget

local bloodColors = {
    [0] = "Blood",
    [1] = "YellowBlood",
    [2] = "YellowBlood",
    [3] = "ManhackSparks",
    [4] = "YellowBlood",
    [5] = "YellowBlood",
    [6] = "YellowBlood"
}

local function playEffects( ent, data )
    if not ( ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() ) or not isBulletDamage( data ) then return end

    if getBloodColor( ent ) ~= -1 then
        ent.bloodColorHitFix = getBloodColor( ent )
        ent:SetBloodColor( -1 )
    end

    if getBloodColor( ent ) ~= -1 then return end

    local bloodColor = ent.bloodColorHitFix

    -- 3 Because robots don't bleed yet they have their own blood type for some reason.
    if not bloodColor or bloodColor == 3 then return end

    local hitPos = data:GetDamagePosition()
    local inflictorEyepos = data:GetAttacker():EyePos()
    local effectData = EffectData()

    effectData:SetOrigin( hitPos )
    effectData:SetColor( bloodColor )
    util.Effect( "BloodImpact", effectData )

    local tempBloodPos = ( hitPos + ( ( inflictorEyepos - hitPos ):GetNormalized() * math_random( -25, -200 ) ) ) + Vector( math_random( -15, 15 ), math_random( -15, 15 ), 0 )
    local bloodPos = tempBloodPos - Vector( 0, 0, 75 )

    local bloodMat = rawget( bloodColors, bloodColor )
    if not bloodMat then return end

    util_Decal( bloodMat, hitPos, tempBloodPos, ent )
    util_Decal( bloodMat, tempBloodPos, bloodPos, ent )
end

hook.Add( "PostEntityTakeDamage", "ResponsiveHits_PostEntityTakeDamage", playEffects )

local function setBloodonSpawn( ent )
    if getBloodColor( ent ) ~= -1 then
        ent.bloodColorHitFix = getBloodColor( ent )
        ent:SetBloodColor( -1 )
    end

    if getBloodColor( ent ) ~= -1 then return end
end

hook.Add( "PlayerSpawn", "ResponsiveHits_PlayerSpawn", setBloodonSpawn )
