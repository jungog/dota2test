local m = {}
local RoundEnemy = LoadKeyValues("scripts/kv/RoundEnemy.kv")

local EnemyList = {

}
print("load roundenemy", RoundEnemy);

--野怪在指定位置生成
--round:第几轮，pos:位置
function m.SpawnEnemyByPos(round, pos,forwardpos)
    for i, v in pairs(RoundEnemy['Round' .. tostring(round)]) do

        print("spawn enemy",i, v["Unit"],pos);
        
        local enemy = CreateUnitByName(v["Unit"], Vector(pos.x + v["X"], pos.y + v["Y"], pos.z), true, nil, nil, DOTA_TEAM_NEUTRALS)
        enemy.SetForwardVector(forwardpos);
    end

end
--野怪是否还有活着的
function m.IsEmenyALive()

end

--清空野怪
function m.ClearEmeny()

end
return m
