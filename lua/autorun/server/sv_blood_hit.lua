local GetBloodColor = FindMetaTable( "Player" ).MetaBaseClass.GetBloodColor
local IsPlayer = FindMetaTable( "Player" ).IsPlayer
local IsBulletDamage = FindMetaTable( "CTakeDamageInfo" ).IsBulletDamage

local util_Decal = util.Decal
local math_random = math.random

local function playEffects( ent, data )
    if not IsPlayer( ent ) or not IsBulletDamage( data ) then return end
    if GetBloodColor( ent ) == 0 then
        ent:SetBloodColor( -1 )
    end

    if GetBloodColor( ent ) ~= -1 then return end

    local hitpos = data:GetDamagePosition()
    local inflictorEyepos = data:GetAttacker():EyePos()
    local effectdata = EffectData()
    effectdata:SetOrigin( hitpos )
    util.Effect( "BloodImpact", effectdata )

    local tempBloodPos = ( hitpos + ( ( inflictorEyepos - hitpos ):GetNormalized() * math_random( -25, -200 ) ) ) + Vector( math_random( -15, 15 ), math_random( -15, 15 ), 0 )
    local bloodPos = tempBloodPos - Vector( 0, 0, 75 )

    util_Decal( "Blood", hitpos, tempBloodPos, ent )
    util_Decal( "Blood", tempBloodPos, bloodPos, ent )
end

hook.Add( "PostEntityTakeDamage", "ResponsiveHits_PostEntityTakeDamage", playEffects )
