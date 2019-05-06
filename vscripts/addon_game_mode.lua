--第三方lib
require("libraries.reg.LibRegister")

-- Create the class for the game mode, unused in this example as the functions for the quest are global
if _G.GameMode == nil then
	_G.GameMode = class({})
end


-- If something was being created via script such as a new npc, it would need to be precached here
local particles = {
    -- "particles/treasure_courier_death.vpcf",
    -- "particles/leader/leader_overhead.vpcf",
    -- "particles/generic_gameplay/screen_damage_indicator.vpcf",
    -- "particles/econ/items/viper/viper_ti7_immortal/viper_poison_crimson_debuff_ti7.vpcf",
    -- "particles/status_fx/status_effect_poison_viper.vpcf",
    -- "particles/generic_gameplay/screen_poison_indicator.vpcf",
    -- "particles/core/border.vpcf",
}

local sounds = {
	-- "soundevents/voscripts/game_sounds_vo_announcer.vsndevts",
}
--从各个文件中加载粒子特效、模型和声音文件
function PrecacheEveryThingFromKV( context )
	local kv_files = {
		"scripts/npc/npc_units_custom.txt",
		"scripts/npc/npc_abilities_custom.txt",
		"scripts/npc/npc_heroes_custom.txt",
		"scripts/npc/npc_items_custom.txt"}
	for index, kv in pairs(kv_files) do
		local kvs = LoadKeyValues(kv)
		if kvs then
			PrecacheEverythingFromTable( context, kvs)
		end
	end
end

--加载粒子特效、模型和声音文件
function PrecacheEverythingFromTable( context, kvtable)
	for key, value in pairs(kvtable) do
		if type(value) == "table" then
			PrecacheEverythingFromTable( context, value);
		elseif type(value) == "string" then
			if string.find(value, "vpcf") then
				PrecacheResource( "particle",  value, context)
			elseif string.find(value, "vmdl") then
				PrecacheResource( "model",  value, context)
			elseif string.find(value, "vsndevts") then
				PrecacheResource( "soundfile",  value, context)
			end
		end
	end
end
--缓存特效
 function PrecacheParticles(context)
	for _, p in pairs(particles) do
        PrecacheResource("particle", p, context)
    end
end
--缓存声音文件
function PrecacheSounds(context)
    for _, p in pairs(sounds) do
        PrecacheResource("soundfile", p, context)
	end
	print("precache sound end")
end
--缓存单位信息
function PrecacheUnits(context)
	for unit in pairs(LoadKeyValues("scripts/npc/npc_units_custom.txt")) do
        PrecacheUnitByNameSync(unit,context,0)
	end
	print("precache unit end")
end

function Precache( context )
	--从kv文件加载数据
	PrecacheEveryThingFromKV( context )
	PrecacheParticles(context)
	PrecacheSounds(context)
	PrecacheUnits(context)
end

require("GameMode")


-- Create the game mode class when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end

-- Begins processing script for the custom game mode.  This "template_example" contains a main OnThink function.
-- function GameMode:InitGameMode()
-- 	print( "Adventure Example loaded." )
-- end


-- -- Quest entity that will contain the quest data so it can be referenced later
-- local entQuestKillBoss = nil


-- -- Call this function from Hammer to start the quest.  Checks to see if the entity has been created, if not, create the entity
-- -- See "adventure_example.vmap" for syntax on accessing functions
-- function QuestKillBoss()
-- 	if entQuestKillBoss == nil then
-- 		entQuestKillBoss = SpawnEntityFromTableSynchronous( "quest", { name = "KillBoss", title = "#quest_boss_kill" } )
-- 	end
-- end


-- -- Call this function to end the quest.  References the previously created quest if it has been created, if not, should do nothing
-- function QuestKillBossComplete()
-- 	if entQuestKillBoss ~= nil then
-- 		entQuestKillBoss:CompleteQuest()
-- 	end
-- end