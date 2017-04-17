--------------------------------------------------------------------------------------------------------
--
--		Hero: Doom Bringer
--		Perk: Demonic spells will have 25% cooldown reduction when cast by Doom.
--
--------------------------------------------------------------------------------------------------------
LinkLuaModifier( "modifier_npc_dota_hero_doom_bringer_perk", "abilities/hero_perks/npc_dota_hero_doom_bringer_perk.lua" ,LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------------------------------
if npc_dota_hero_doom_bringer_perk ~= "" then npc_dota_hero_doom_bringer_perk = class({}) end

function npc_dota_hero_doom_bringer_perk:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_doom_bringer_perk"
end
--------------------------------------------------------------------------------------------------------
--		Modifier: modifier_npc_dota_hero_doom_bringer_perk				
--------------------------------------------------------------------------------------------------------
if modifier_npc_dota_hero_doom_bringer_perk ~= "" then modifier_npc_dota_hero_doom_bringer_perk = class({}) end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_doom_bringer_perk:IsPassive()
	return true
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_doom_bringer_perk:IsHidden()
	return false
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_doom_bringer_perk:IsPurgable()
	return false
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_doom_bringer_perk:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------------------------------
-- Add additional functions
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_doom_bringer_perk:OnCreated(keys)
	self.cooldownPercentReduction = 75
	self.cooldownReduction = self.cooldownPercentReduction / 100
	return true
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_doom_bringer_perk:DeclareFunctions()
	local funcs = {
	  MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_doom_bringer_perk:OnAbilityFullyCast(keys)
  if IsServer() then
    local hero = self:GetCaster()
    local target = keys.target
    local ability = keys.ability
    if hero == keys.unit and ability and ability:HasAbilityFlag("demon") then
	  local cooldown = ability:GetCooldownTimeRemaining() * self.cooldownReduction
      ability:EndCooldown()
      ability:StartCooldown(cooldown)
	end
  end
end
