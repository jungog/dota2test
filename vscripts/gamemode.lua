--初始化
function GameMode:InitGameMode()
    -- local  mapName = GetMapName()
    print("init11");


-- body
end

-- 伤害过滤器
function GameMode:DamageFilter(damageTable)
-- damageTable.entindex_attacker_const
-- damageTable.entindex_victim_const
-- damageTable.damage
end

-- 指令过滤器
function GameMode:OrderFilter(filterTable)
-- filterTable.entindex_ability
end
-- buff过滤器
function GameMode:ModifierFilter(filterTable)
-- filterTable.name_const
-- filterTable.entindex_ability_const
-- filterTable.entindex_caster_const
-- filterTable.duration
end

-- 经验值过滤器
function GameMode:ModifyExpFilter(filterTable)
-- local playerid = filterTable.player_id_const
-- local exp = filterTable.experience
-- local reason = filterTable.reason_const
end

-- 金币过滤器
function GameMode:ModifyGoldFilter(filterTable)
-- local reason = filterTable.reason_const
-- local reliable = filterTable.reliable
-- local gold = filterTable.gold
-- local payer_id = filterTable.player_id_const
end
