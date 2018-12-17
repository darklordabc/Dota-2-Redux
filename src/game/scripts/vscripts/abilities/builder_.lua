
-- Lua Library Imports
builder = builder or {}
builder.__index = builder
function builder.new(construct, ...)
    local self = setmetatable({}, builder)
    if construct and builder.constructor then builder.constructor(self, ...) end
    return self
end
function builder.constructor(self)
end
function builder.GetSoundName(self)
    return "Redux.PocketTower"
end
function builder.PlayBuildParticle(self,location)
    local dust_pfx = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit_detail.vpcf",PATTACH_CUSTOMORIGIN,nil);
    ParticleManager:SetParticleControl(dust_pfx,0,location);
    ParticleManager:ReleaseParticleIndex(dust_pfx);
end
function builder.GetUnitName(self)
    return "npc_dota_badguys_tower4"
end
function builder.OnBuildingPlaced(self,location,building)
end
function builder.CastFilterResultLocation(self,location)
    if IsClient() then
        return UF_SUCCESS
    end
    local buildings = FindUnitsInRadius(self:GetCaster():GetTeam(),location,nil,144,DOTA_UNIT_TARGET_TEAM_BOTH,(DOTA_UNIT_TARGET_BUILDING+DOTA_UNIT_TARGET_HERO)+DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_INVULNERABLE,FIND_ANY_ORDER,false);
    if ((not GridNav:IsTraversable(location)) or (#buildings>0)) or self:GetCaster():IsPositionInRange(location,144+self:GetCaster():GetHullRadius()) then
        return UF_FAIL_CUSTOM
    else
        return UF_SUCCESS
    end
end
function builder.GetCustomCastErrorLocation(self,location)
    return "#dota_hud_error_no_buildings_here"
end
function builder.OnSpellStart(self)
    local caster = self:GetCaster();
    local location = self:GetCursorPosition();
    local buildingName = self:GetUnitName();
    local building = CreateUnitByName(buildingName,location,true,caster,caster:GetPlayerOwner(),caster:GetTeam());
    building:SetOwner(caster);
    building:SetOrigin(GetGroundPosition(location,building));
    GridNav:DestroyTreesAroundPoint(location,building:GetHullRadius(),true);
    building:RemoveModifierByName("modifier_invulnerable");
    building:RemoveAbility("backdoor_protection_in_base");
    self:PlayBuildParticle(location);
    building:EmitSound(self:GetSoundName());
    self:OnBuildingPlaced(location,building);
    Timers:CreateTimer(0.01,function()
        ResolveNPCPositions(location,144);
    end
);
end
