-----------------roommgr test--------------
-- local t = RoomMgr.GetRoomData(3);
-- print(t.IsFull);
-- RoomMgr.FindEmptyRoomPos(11, nil);
-- RoomMgr.FindEmptyRoomPos(12, nil);
-- RoomMgr.FindEmptyRoomPos(13, nil);
-- RoomMgr.FindEmptyRoomPos(14, nil);
-- RoomMgr.FindEmptyRoomPos(15, nil);
-- RoomMgr.FindEmptyRoomPos(16, nil);
-- RoomMgr.FindEmptyRoomPos(17, nil);
-- RoomMgr.FindEmptyRoomPos(18, nil);
-- RoomMgr.FindEmptyRoomPos(19, nil);
-- RoomMgr.FindEmptyRoomPos(20, nil);
-- RoomMgr.FindEmptyRoomPos(21, nil);
-- for i = 1, 9 do
--     local t = RoomMgr.GetRoomData(i)
--     print(t.IsFull, t.Type, t.AID, t.BID);
-- end
-----------------roommgr test end--------------

-----------gamerules---------------------------
--[[
local gamemode = GameRules:GetGameModeEntity()
self.gamemode = gamemode
GameRules.gamemode = gamemode
--允许选择重复英雄
GameRules:SetSameHeroSelectionEnabled(true)
--所有物品当处于任意商店范围内时都能购买到，包括秘密商店物品
GameRules:SetUseUniversalShopMode(true)
--设置选择英雄的时间
GameRules:SetHeroSelectionTime(0.1)
--设置策略阶段的时间
GameRules:SetStrategyTime(3)
--设置“dota2”展示屏幕的持续时间
GameRules:SetShowcaseTime(1)
--设置选择英雄与开始游戏之间的时间
GameRules:SetPreGameTime(60)
--设置在结束游戏后服务器与玩家断线前的时间
GameRules:SetPostGameTime(180)
--设置树重新生长的时间（秒）
GameRules:SetTreeRegrowTime(5)
--设置获得金币的时间周期
GameRules:SetGoldTickTime(0.4)
--设置每个时间间隔获得的金币
GameRules:SetGoldPerTick(2)
--设置初始金钱
GameRules:SetStartingGold(1200)
--使幻象死亡时立即消失，而不是延迟数秒
gamemode:SetRemoveIllusionsOnDeath(true)
--开关战争迷雾
gamemode:SetFogOfWarDisabled(false)
--设置默认的镜头距离Dota默认为1134
gamemode:SetCameraDistanceOverride(1500)
--设置金钱处罚开关
gamemode:SetSelectionGoldPenaltyEnabled(false)
--设置禁用死亡时损失金钱
gamemode:SetLoseGoldOnDeath(false)
--完全允许/禁止买活
gamemode:SetBuybackEnabled(false)
--设置一个过滤器，用来控制单位受到伤害时的行为 (改变数据表并返回True来使用新值, 返回False来取消事件)
gamemode:SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
--设置一个过滤器，用来控制单位捡起物品时的行为 (改变数据表并返回True来使用新值, 返回False来取消事件)
gamemode:SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "OrderFilter"), self)
--设置一个过滤器，用来控制Modifier的获得, 返回Flase来删除Modifier
gamemode:SetModifierGainedFilter(Dynamic_Wrap(GameMode, 'ModifierFilter'), self)
--设置一个过滤器，用来控制英雄的金钱被改变时的行为(改变数据表并返回True来使用新值, 返回False来取消事件)
gamemode:SetModifyGoldFilter(Dynamic_Wrap(GameMode, "ModifyGoldFilter"), self)
--设置一个过滤器，用来控制英雄经验值被改变时的行为(改变数据表并返回True来使用新值, 返回False来取消事件)
gamemode:SetModifyExperienceFilter(Dynamic_Wrap(GameMode, "ModifyExpFilter"), self)
]]
-----------gamerules end---------------------------
