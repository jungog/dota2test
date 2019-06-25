--第三方lib
require('libraries.reg.LibRegister')
--游戏逻辑
require('gamelogic.reg.gameregister')
--ui事件
require('ui')

-- Create the class for the game mode, unused in this example as the functions for the quest are global
if CubeGame == nil then
    CubeGame = class({})
    _G.CubeGame = CubeGame
end

-- If something was being created via script such as a new npc, it would need to be precached here
local particles = {}

local sounds = {}
--从各个文件中加载粒子特效、模型和声音文件
function PrecacheEveryThingFromKV(context)
    local kv_files = {
        'scripts/npc/npc_units_custom.txt',
        'scripts/npc/npc_abilities_custom.txt',
        'scripts/npc/npc_heroes_custom.txt',
        'scripts/npc/npc_items_custom.txt'
    }
    for index, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then
            PrecacheEverythingFromTable(context, kvs)
        end
    end
end

--加载粒子特效、模型和声音文件
function PrecacheEverythingFromTable(context, kvtable)
    for key, value in pairs(kvtable) do
        if type(value) == 'table' then
            PrecacheEverythingFromTable(context, value)
        elseif type(value) == 'string' then
            if string.find(value, 'vpcf') then
                PrecacheResource('particle', value, context)
            elseif string.find(value, 'vmdl') then
                PrecacheResource('model', value, context)
            elseif string.find(value, 'vsndevts') then
                PrecacheResource('soundfile', value, context)
            end
        end
    end
end
--缓存特效
function PrecacheParticles(context)
    for _, p in pairs(particles) do
        PrecacheResource('particle', p, context)
    end
end
--缓存声音文件
function PrecacheSounds(context)
    for _, p in pairs(sounds) do
        PrecacheResource('soundfile', p, context)
    end
    print('precache sound end')
end
--缓存单位信息
function PrecacheUnits(context)
    for unit in pairs(LoadKeyValues('scripts/npc/npc_units_custom.txt')) do
        PrecacheUnitByNameSync(unit, context, 0)
    end
    print('precache unit end')
end

function Precache(context)
    --从kv文件加载数据
    PrecacheEveryThingFromKV(context)
    PrecacheParticles(context)
    PrecacheSounds(context)
    PrecacheUnits(context)
end

-- Create the game mode class when we activate
function Activate()
    GameRules.AddonTemplate = CubeGame()
    GameRules.AddonTemplate:InitGameMode()
end

-- Begins processing script for the custom game mode.  This "template_example" contains a main OnThink function.
function CubeGame:InitGameMode()
    print('init')

    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 0)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_1, 1)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_2, 1)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_3, 1)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_4, 1)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_5, 1)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_6, 1)

    GameRules:GetGameModeEntity():SetPauseEnabled(false)
    GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)
    GameRules:SetStrategyTime(0)
    --设置英雄选择后的决策时间
    GameRules:SetShowcaseTime(0)
    --设置 天辉vs夜魇 界面的显示时间。
    GameRules:SetSameHeroSelectionEnabled(true)
    --允许选择重复英雄

    GameRules:SetPreGameTime(60)
    --设置选择英雄与开始游戏之间的时间，给玩家选择固定的自动英雄todo
    GameRules:GetGameModeEntity():SetCustomGameForceHero('npc_dota_hero_wisp')
    --自动为玩家选择艾欧todo

    ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(CubeGame, 'OnPlayerPickHero'), self)
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(CubeGame, 'OnGameRulesStateChange'), self)

    --注册UI监听
    self:RegisterUIEventListeners()

    RoomMgr.InitRoomData()
    local cout = 6
    for i = 1, 6 do
        local pos = RoomMgr.SetEmptyRoomPos(i, nil)

        Enemy.SpawnEnemyByPos(1, cout, pos, nil)
        cout = cout + 1
    end

    -- 自动为玩家选择英雄
    -- 让玩家选自动英雄 30s
    -- 选房间10s
    -- 战斗40s
    -- 掉落
    -- 休整20s
end

function CubeGame:OnGameRulesStateChange(keys)
    -- print(" GameRules State Changed")
    local newState = GameRules:State_Get()
    print(' StateChange', newState)
end

--接收到自动为玩家选择英雄后，等所有人自动选好英雄后，弹出选自动英雄画面，让玩家选择，超时后自动为玩家选择三个英雄
function CubeGame:OnPlayerPickHero(keys)
    print(' PlayerPickHero')
    --弹出选英雄画面
    table.print(keys)

    if not IsServer() then
        return
    end
    local player = EntIndexToHScript(keys.player)
    if (player == nil) then
        return
    end

    local playerId = player:GetPlayerID()
    local hero = EntIndexToHScript(keys.heroindex)

    hero:SetForwardVector(Vector(0, 1, 0))
    hero:SetDeathXP(0)
    hero:SetHullRadius(1)
    hero:SetAbilityPoints(0)
    for i = 1, 16 do
        hero:RemoveAbility('empty' .. i)
    end
    hero:SetMana(0)

    -- Timers:CreateTimer(
    --     20,
    --     function()
    --         for i = 6, 11 do
    --             print('1', Enemy.IsEmenyALive(i))
    --         end
    --         Enemy.ClearAllEmeny()
    --         Timers:CreateTimer(
    --             10,
    --             function()
    --                 for i = 6, 11 do
    --                     print('2', Enemy.IsEmenyALive(i))
    --                 end
    --             end
    --         )
    --     end
    -- )
end
