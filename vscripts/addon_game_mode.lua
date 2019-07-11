--第三方lib
require('libraries.reg.LibRegister')
--游戏逻辑
require('gamelogic.reg.gameregister')

-- Create the class for the game mode, unused in this example as the functions for the quest are global
if CubeGame == nil then
    CubeGame = class({})
    _G.CubeGame = CubeGame
end

--ui事件
require('ui')
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
-- print('precache sound end')
end
--缓存单位信息
function PrecacheUnits(context)
    for unit in pairs(LoadKeyValues('scripts/npc/npc_units_custom.txt')) do
        PrecacheUnitByNameSync(unit, context, 0)
    end
-- print('precache unit end')
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
    ListenToGameEvent('player_connect_full', Dynamic_Wrap(CubeGame, 'OnConnectFull'), self)
    ListenToGameEvent('player_disconnect', Dynamic_Wrap(CubeGame, 'OnDisconnect'), self)
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(CubeGame, 'OnGameRulesStateChange'), self)
    ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(CubeGame, 'OnPlayerPickHero'), self)
    --注册UI监听
    self:RegisterUIEventListeners()
    
    RoomMgr.InitRoomData()
    
    if GameRules.CubeGame == nil then
        -- print('init GameRules.CubeGame == nil')
        GameRules.CubeGame = {}
        GameRules.CubeGame.GameId = ''
        GameRules.CubeGame.MaxNormalRound = 12
        GameRules.CubeGame.RoundNo = 0
        GameRules.CubeGame.PlayerList = {}
        GameRules.CubeGame.Playerid2Teamid = {}
        GameRules.CubeGame.Teamid2Playerid = {}
        for playerid = 0, 7 do
            local playerInfo = {}
            playerInfo.SteamId = ''
            playerInfo.SteamAccountId = ''
            playerInfo.PlayerName = ''
            playerInfo.TeamId = 0
            playerInfo.HP = 100
            playerInfo.IsAlive = true
            playerInfo.IsBot = false
            playerInfo.IsEmpty = true
            playerInfo.IsOnline = false
            playerInfo.RoomType = ''
            
            playerInfo.Heros = {
                [1] = {Vec = Vector(80, 0, 0), Name = ''},
                [2] = {Vec = Vector(0, 0, 0), Name = ''},
                [3] = {Vec = Vector(-80, 0, 0), Name = ''}
            }
            playerInfo.Abilitys = {}
            -- todo背包和掉落栏
            GameRules.CubeGame.PlayerList[playerid] = playerInfo
        end
    end
    
    -- local cout = 6;
    -- for i = 1, 6 do
    --     local pos = RoomMgr.SetEmptyRoomPos(i, nil);
    --     Enemy.SpawnEnemyByPos(1, cout, pos, nil);
    --     cout = cout + 1;
    -- end
    -- 自动为玩家选择英雄 30s
    -- 让玩家选自动英雄 30s
    -- 选房间10s
    -- 战斗40s
    -- 掉落
    -- 休整20s
    SendToServerConsole("dota_max_physical_items_purchase_limit 9999")
end
function CubeGame:OnConnectFull(keys)
    local playerId = keys.PlayerID
    -- table.print(keys)
    GameRules.CubeGame.PlayerList[playerId].SteamId = tostring(PlayerResource:GetSteamID(playerId))
    GameRules.CubeGame.PlayerList[playerId].SteamAccountId = tostring(PlayerResource:GetSteamAccountID(playerId))
    GameRules.CubeGame.PlayerList[playerId].PlayerName = tostring(PlayerResource:GetPlayerName(playerId))
    GameRules.CubeGame.PlayerList[playerId].IsOnline = true
    GameRules.CubeGame.PlayerList[playerId].IsBot = false
    GameRules.CubeGame.PlayerList[playerId].IsEmpty = false

-- todo 是否要包括玩家选的英雄&技能呢
end
function CubeGame:OnDisconnect(keys)
    local playerId = keys.PlayerID
    if (playerId >= 0 and GameRules.CubeGame.PlayerList[playerId] ~= nil) then
        GameRules.CubeGame.PlayerList[playerId].IsOnline = false
    end
end
function CubeGame:OnGameRulesStateChange(keys)
    -- print(" GameRules State Changed")
    local newState = GameRules:State_Get()
-- print(' StateChange', newState)
end

--接收到自动为玩家选择英雄后，等所有人自动选好英雄后，弹出选自动英雄画面，让玩家选择，超时后自动为玩家选择三个英雄
function CubeGame:OnPlayerPickHero(keys)
    print(' PlayerPickHero')
    --弹出选英雄画面
    -- table.print(keys)
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
    
    GameRules.CubeGame.Playerid2Teamid[player:GetPlayerID()] = hero:GetTeam()
    GameRules.CubeGame.Teamid2Playerid[hero:GetTeam()] = player:GetPlayerID()
    
    GameRules.CubeGame.PlayerList[playerId].TeamId = hero:GetTeam()
    
    local playercount = 0
    for _, _ in pairs(GameRules.CubeGame.Teamid2Playerid) do
        playercount = playercount + 1
    end
    
    print('PlayerCount: ' .. playercount .. '/' .. PlayerResource:GetPlayerCount())
    
    if playercount == PlayerResource:GetPlayerCount() then
        Timers:CreateTimer(
            0.1,
            function()
                InitHeros()
            end
    )
    -- Timers:CreateTimer(20, function()
    --     for i = 6, 11 do
    --         print("1", Enemy.IsEmenyALive(i));
    --     end
    --     Enemy.ClearAllEmeny();
    --     Timers:CreateTimer(10, function()
    --         for i = 6, 11 do
    --             print("2", Enemy.IsEmenyALive(i));
    --         end
    --     end)
    -- end)
    end
end

function InitHeros()
    print(' InitHeros')
    -- todo向客户端发送英雄列表，等待玩家选择英雄
    Timers:CreateTimer(
        SelectHeroTime,
        function()
            -- 30秒后检查玩家是否选好，没选好就自动帮玩家选，然后进入1选房间环节
            for i, Val in pairs(GameRules.CubeGame.PlayerList) do
                -- print('InitHeros', i)
                -- table.print(Val)
                if not Val.IsEmpty then
                    -- print('not IsEmpty')
                    for _, hero in pairs((Val.Heros)) do
                        -- print(' hero.name before', hero.Name)
                        if hero.Name == '' then
                            -- print(' hero.name nil')
                            hero.Name = table.random(AllHeroNames)
                        end
                    -- print(' hero.name', hero.Name)
                    end
                end
            end
            
            SelectRoom()
        end
)
end

-- 游戏环节1 选择房间
function SelectRoom()
    print(' SelectRoom')
    -- 清空玩家上一次选择的房间类型
    for _, Val in pairs(GameRules.CubeGame.PlayerList) do
        if not Val.IsEmpty then
            Val.RoomType = nil
        end
    end
    -- 游戏参数变更
    GameRules.CubeGame.RoundNo = GameRules.CubeGame.RoundNo + 1
    if GameRules.CubeGame.RoundNo > GameRules.CubeGame.MaxNormalRound then
        -- todo 超过MaxNormalRound进入死亡模式
        end
    --todo 向客户端展示选房间画面，等待玩家选房间
    Timers:CreateTimer(
        SelectRoomTime,
        function()
            print("player2teamid ", GameRules.CubeGame.Playerid2Teamid);
            -- 10秒后检查玩家是否选好，没选好就自动帮玩家选房间,然后2准备环节
            for i, Val in pairs(GameRules.CubeGame.PlayerList) do
                if not Val.IsEmpty then
                    if Val.RoomType == nil then
                        RoomMgr.SetEmptyRoomPos(i, nil)
                    else
                        RoomMgr.SetEmptyRoomPos(i, Val.RoomType)
                    end
                    Val.RoomType = RoomMgr.GetRoomTypeByPlayerId(i)
                    print("playerid:", i, ",roomtype:", Val.RoomType)
                end
            -- print(' Val.RoomType', Val.RoomType)
            end
            Prepare()
        end
)
end

-- 游戏环节2 准备环节
function Prepare()
    print('Prepare')
    -- 把玩家移动到固定位置
    for playerId, playerInfo in pairs(GameRules.CubeGame.PlayerList) do
        if not playerInfo.IsEmpty then
            -- table.print(playerInfo)
            local pos = RoomMgr.GetSelfPosByPlayerId(playerId)
            local targetpos = RoomMgr.GetEnemyPosById(playerId)
            local heros = playerInfo.Heros
            local teamid = playerInfo.TeamId
            for i = 1, 3 do
                -- table.print(heros[i])
                local herounit =
                    CreateUnitByName(
                        HeroNamePrefix .. heros[i].Name,
                        pos + heros[i].Vec,
                        true,
                        nil,
                        nil,
                        playerInfo.TeamId
                )
                -- print('create info', HeroNamePrefix .. heros[i].Name, pos + heros[i].Vec)
                -- print('create', herounit)
                -- table.print(herounit)
                herounit:SetControllableByPlayer(playerId, true)
                herounit:SetHealth(herounit:GetMaxHealth())
                herounit:SetMana(herounit:GetMaxMana())
                herounit:SetForwardVector(targetpos)
                herounit:SetTeam(teamid)
                print('Prepare', herounit)
            end
        end
    end
    -- 生成pve怪
    for _, playerInfo in pairs(GameRules.CubeGame.PlayerList) do
        if not playerInfo.IsEmpty then
            RoomMgr.LoadEnemyInSingleRoom(GameRules.CubeGame.RoundNo, playerInfo.TeamId)
        end
    end
    
    -- 3秒后开战
    Timers:CreateTimer(
        PrepareTime,
        function()
            Battle()
        end
)
end

-- 游戏环节3 开战
function Battle()
    print('Battle')
    
    -- 让英雄移动，相遇，战斗
    Timers:CreateTimer(
        BattleTime,
        function()
        --    战斗时间结束，来检查胜负，发放奖励，清理战场
        
        end
)
end
