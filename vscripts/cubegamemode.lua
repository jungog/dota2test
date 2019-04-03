
--初始化
function CubeGameMode:InitGameMode()
    --local  mapName = GetMapName()
    print("init",mapName);

    GameRules:SetSameHeroSelectionEnabled(true)
    GameRules:SetUseUniversalShopMode(true)
    GameRules:SetHeroSelectionTime(0.1)
    GameRules:SetStrategyTime(3)
    GameRules:SetShowcaseTime(1)
    GameRules:SetPreGameTime(60)
    GameRules:SetPostGameTime(180)
    GameRules:SetTreeRegrowTime(5)
    GameRules:SetGoldTickTime(0.4)
    GameRules:SetGoldPerTick(2)
    GameRules:SetStartingGold(GameRules.nStartingGold)
    gamemode:SetRemoveIllusionsOnDeath(true)
    gamemode:SetFogOfWarDisabled(false)
    gamemode:SetCameraDistanceOverride(1500)
    gamemode:SetSelectionGoldPenaltyEnabled(false)
    gamemode:SetLoseGoldOnDeath(false)
    gamemode:SetBuybackEnabled(false)
    gamemode:SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
    gamemode:SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "OrderFilter"), self)
    gamemode:SetModifierGainedFilter(Dynamic_Wrap(GameMode, 'ModifierFilter'), self)
    gamemode:SetModifyGoldFilter(Dynamic_Wrap(GameMode, "ModifyGoldFilter"), self)
    gamemode:SetModifyExperienceFilter(Dynamic_Wrap(GameMode, "ModifyExpFilter"), self)
    -- body
end