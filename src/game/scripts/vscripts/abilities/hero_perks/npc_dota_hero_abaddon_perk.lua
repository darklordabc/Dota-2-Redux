--------------------------------------------------------------------------------------------------------
--
--		Hero: Abaddon
--		Perk: 
--
--------------------------------------------------------------------------------------------------------
LinkLuaModifier( "modifier_npc_dota_hero_abaddon_perk", "abilities/hero_perks/npc_dota_hero_abaddon_perk.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_charges", "abilities/modifiers/modifier_charges.lua", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------------------------------
if npc_dota_hero_abaddon_perk == nil then npc_dota_hero_abaddon_perk = class({}) end

function npc_dota_hero_abaddon_perk:GetIntrinsicModifierName()
    return "modifier_npc_dota_hero_abaddon_perk"
end
--------------------------------------------------------------------------------------------------------
--		Modifier: modifier_npc_dota_hero_abaddon_perk				
--------------------------------------------------------------------------------------------------------
if modifier_npc_dota_hero_abaddon_perk == nil then modifier_npc_dota_hero_abaddon_perk = class({}) end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_abaddon_perk:IsPassive()
	return true
end
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_abaddon_perk:IsHidden()
	return true
end

function modifier_npc_dota_hero_abaddon_perk:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------------------------------
-- Add additional functions
--------------------------------------------------------------------------------------------------------
function modifier_npc_dota_hero_abaddon_perk:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
	return funcs
end

function modifier_npc_dota_hero_abaddon_perk:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_npc_dota_hero_abaddon_perk:OnIntervalThink()
	if not self.activated then
		local shield = self:GetParent():FindAbilityByName("abaddon_aphotic_shield")
		if shield and shield:GetLevel() > 0 then
			self:GetParent():AddNewModifier(self:GetParent(), shield, "modifier_charges",
				{
					max_count = 2,
					start_count = 1,
					replenish_time = shield:GetCooldown(-1)
				}
			)
		end
		self.activated = true
	end
end

local Timers = require('easytimers')

function PerkAbaddon(filterTable)
	local victim_index = filterTable["entindex_victim_const"]
    local attacker_index = filterTable["entindex_attacker_const"]
    local ability_index = filterTable["entindex_inflictor_const"]
    if not victim_index or not attacker_index or not ability_index then
        return true
    end
    
    local attacker = EntIndexToHScript( victim_index )
    local victim = EntIndexToHScript( attacker_index )
    local ability = EntIndexToHScript( ability_index )
	local targetPerk = attacker:FindAbilityByName(attacker:GetName() .. "_perk")
	if targetPerk and targetPerks_damage[targetPerk:GetName()] then
		if ability and ability:GetName() == "abaddon_death_coil" and attacker == victim then
			filterTable["damage"] = 0
			attacker:Heal(ability:GetSpecialValueFor("self_damage"), attacker)
		end
	end
 end

function modifier_npc_dota_hero_abaddon_perk:OnAbilityExecuted(params)
	if params.unit == self:GetParent() then
		if params.ability:GetName() == "abaddon_aphotic_shield" then
			local shield = params.ability
			local stacks = self:GetParent():GetModifierStackCount("modifier_charges", self:GetParent())
			if not self:GetParent():HasModifier("modifier_charges") then
				self:GetParent():AddNewModifier(self:GetParent(), shield, "modifier_charges",
						{
							max_count = 2,
							start_count = 1,
							replenish_time = shield:GetCooldown(-1)
						}
					)
			end
			if stacks < 1 then
				shield:StartCooldown(shield:GetTrueCooldown())
			end
			if stacks > 1 then
				 Timers:CreateTimer(function()
					if not shield:IsCooldownReady() then
						shield:EndCooldown()
					else
						return 0.01
					end
				end, DoUniqueString('abbadonShield'), 0.01)
			end
		end
	end
end
