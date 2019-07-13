local m = {}
local RoundEnemy = LoadKeyValues('scripts/kv/RoundEnemy.kv')

local EnemyList = {
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {},
    [11] = {}
}
print('load roundenemy', RoundEnemy)

--野怪在指定位置生成
--round:第几轮，pos:位置,forwardpos:朝向位置
function m.SpawnEnemyByPos(round, teamid, pos, forwardpos)
    for i, v in pairs(RoundEnemy['Round' .. tostring(round)]) do
        print('spawn enemy', i, v['Unit'], pos)
        
        local enemy =
            CreateUnitByName(
                v['Unit'],
                Vector(pos.x + v['X'], pos.y + v['Y'], pos.z),
                true,
                nil,
                nil,
                DOTA_TEAM_NEUTRALS
        )
        table.insert(EnemyList[teamid], enemy)
        enemy:SetForwardVector(forwardpos)
    end
    return EnemyList[teamid]
end
--野怪是否还有活着的
function m.IsEmenyALive(teamid)
    for _, v in pairs(EnemyList[teamid]) do
        if v ~= nil and v:IsNull() == false then
            return true
        end
    end
    return false
end

--清空野怪
function m.ClearAllEmeny()
    for _, team in pairs(EnemyList) do
        for _, v in pairs(team) do
            if v ~= nil and v:IsNull() == false then
                Timers:CreateTimer(
                    RandomFloat(0.1, 0.3),
                    function()
                        v:Destroy()
                    end
            )
            end
        end
    end
end
return m
