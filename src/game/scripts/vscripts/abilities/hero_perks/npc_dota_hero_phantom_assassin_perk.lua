--------------------------------------------------------------------------------------------------------
--
--		Hero: Phantom Assassin
--		Perk: Dagger spells will have 50% of their manacost refunded, and their cooldown reduced by 2 second. 
--
--------------------------------------------------------------------------------------------------------
LinkLuaModifier( "modifier_npc_dota_hero_phantom_assassin_perk", "abilities/hero_perks/npc_dota_hero_phantom_assassin_perk.lua" ,LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------------------------------
if npc_dota_hero_phantom_assassin_perk == nil then npc_dota_hero_phantom_assassin_perk = class({}) end
--------------------------------------------------------------------------------------------------------
--		Modifier: modifier_npc_dota_hero_phantom_assassin_perk				
--------------------------------------------------------------------------------------------------------
if modifier_npc_dota_hero_phantom_assassin_perk == nil then modifier_npc_dota_hero_phantom_assassin_perk = class({}) end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_phantom_assassin_perk:IsPassive()
	return true
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_phantom_assassin_perk:IsHidden()
	return true
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_phantom_assassin_perk:OnCreated(keys)
	self.cooldownBaseReduction = 2
	self.manaPercentReduction = 50

	self.manaReduction = 1 - (self.manaPercentReduction / 100)
	return true
end
--------------------------------------------------------------------------------------------------------
-- Add additional functions
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_phantom_assassin_perk:DeclareFunctions()
  local funcs = {
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
  }
  return funcs
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_phantom_assassin_perk:OnAbilityFullyCast(keys)
  if IsServer() then
	local hero = self:GetCaster()
	local target = keys.target
	local ability = keys.ability
	if hero == keys.unit and ability and ability:HasAbilityFlag("dagger") then
	  hero:GiveMana(ability:GetManaCost(ability:GetLevel()) * self.manaReduction)
	  if ability:GetCooldownTimeRemaining() > 1.05 then
		ability:EndCooldown()
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel() - 1) - self.cooldownBaseReduction)
	  end
	end
  end
end
