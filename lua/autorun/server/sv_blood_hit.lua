local function playEffects( ent, data )
    if not ent:IsPlayer() or not data:IsBulletDamage() then return end
    if ent:GetBloodColor() == 0 then
        ent:SetBloodColor( -1 )
    end

    if ent:GetBloodColor() ~= -1 then return end

    local hitpos = data:GetDamagePosition()
    local inflictorEyepos = data:GetAttacker():EyePos()
    local effectdata = EffectData()
    effectdata:SetOrigin( hitpos )
    util.Effect( "BloodImpact", effectdata )

    local tempBloodPos = ( hitpos + ( ( inflictorEyepos - hitpos ):GetNormalized() * math.random( -25, -200 ) ) ) + Vector( math.random( -15, 15 ), math.random( -15, 15 ), 0 )
    local bloodPos = tempBloodPos - Vector( 0, 0, 75 )

    util.Decal( "Blood", hitpos, tempBloodPos, ent )
    util.Decal( "Blood", tempBloodPos, bloodPos, ent )
end

hook.Add( "PostEntityTakeDamage", "ResponsiveHits_PostEntityTakeDamage", playEffects )
