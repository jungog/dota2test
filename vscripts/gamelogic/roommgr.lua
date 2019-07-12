local m = {}
local MAX_ROOM_NUM = 9
local Room = {
    [1] = {},
    [2] = {},
    [3] = {},
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {}
}

function m.InitRoomData()
    local RoomData = LoadKeyValues('scripts/kv/RoomData.kv')
    
    for i = 1, MAX_ROOM_NUM do
        Room[i].IsFull = false
        Room[i].Type = RoomData[tostring(i)]['Type']
        Room[i].APlayerID = -1
        Room[i].ATeamID = -1
        Room[i].AHeros = {}
        Room[i].BPlayerID = -1
        Room[i].BTeamID = -1
        Room[i].BHeros = {}
        Room[i].APos = Vector(RoomData[tostring(i)]['A_X'], RoomData[tostring(i)]['A_Y'], RoomData[tostring(i)]['A_Z'])
        Room[i].BPos = Vector(RoomData[tostring(i)]['B_X'], RoomData[tostring(i)]['B_Y'], RoomData[tostring(i)]['B_Z'])
    -- print("room", i, Room[i].IsFull, Room[i].APlayerID, Room[i].APos);
    end
end

function m.ClearAllRoomData()
    for i = 1, MAX_ROOM_NUM do
        Room[i].IsFull = false
        Room[i].APlayerID = -1
        Room[i].ATeamID = -1
        Room[i].AHeros = {}
        Room[i].BPlayerID = -1
        Room[i].BTeamID = -1
        Room[i].BHeros = {}
    end
end

function m.GetRoomDataByIndex(k)
    if k <= MAX_ROOM_NUM then
        return Room[k]
    end
end

function m.GetEnemyPosByPlayerId(id)
    for i = 1, MAX_ROOM_NUM do
        if Room[i].APlayerID == id then
            return Room[i].BPos
        end
        if Room[i].BPlayerID == id then
            return Room[i].APos
        end
    end
end

local TypeNum = {
    ['Strength'] = {1, 4, 7},
    ['Agility'] = {2, 5, 8},
    ['Intelligence'] = {3, 6, 9}
}
--id:玩家id,t:玩家选择的房间类型，nil为全随机，ret为地图所在位置
function m.SetEmptyRoomPosByPlayerId(id, t)
    if t == nil then
        local ta = MathNumber.GetRandomNumList(MAX_ROOM_NUM)
        for _, v in pairs(ta) do
            if not Room[v].IsFull then
                return m.SetRoomId(Room[v], id)
            end
        end
    else
        local ta = MathNumber.GetRandomNumList(3)
        -- print("---start----", table.print(ta), "---end----");
        for _, v in pairs(ta) do
            if not Room[TypeNum[t][v]].IsFull then
                -- print("value", v, TypeNum[t][v]);
                return m.SetRoomId(Room[TypeNum[t][v]], id)
            end
        end
    end
end

function m.GetRoomTypeByPlayerId(id)
    for i = 1, MAX_ROOM_NUM do
        if Room[i].APlayerID == id or Room[i].BPlayerID == id then
            return Room[i].Type
        end
    end
end

function m.GetSelfPosByPlayerId(id)
    for i = 1, MAX_ROOM_NUM do
        if Room[i].APlayerID == id then
            return Room[i].APos
        end
        if Room[i].BPlayerID == id then
            return Room[i].BPos
        end
    end
end

function m.GetEnemyPosByPlayerId(id)
    for i = 1, MAX_ROOM_NUM do
        if Room[i].APlayerID == id then
            return Room[i].BPos
        end
        if Room[i].BPlayerID == id then
            return Room[i].APos
        end
    end
end

function m.LoadEnemyInSingleRoom(round, teamid)
    for i = 1, MAX_ROOM_NUM do
        if Room[i].IsFull == false then
            if Room[i].ATeamID == teamid then
                Room[i].BHeros = Enemy.SpawnEnemyByPos(round, teamid, Room[i].BPos, Room[i].APos)
            elseif Room[i].BTeamID == teamid then
                Room[i].AHeros = Enemy.SpawnEnemyByPos(round, teamid, Room[i].APos, Room[i].BPos)
            end
            Room[i].IsFull = true
        end
    end
end

function m.MoveAllHeros()
    for i = 1, MAX_ROOM_NUM do
        if Room[i].IsFull == true then
            for j = 1, #Room[i].AHeros do
                Room[i].AHeros[j]:MoveToTargetToAttack(Room[i].BPos);
            end
            for j = 1, #Room[i].BHeros do
                Room[i].BHeros[j]:MoveToTargetToAttack(Room[i].APos);
            end
        end
    end

end

--内部函数--
function m.SetRoomId(room, id)
    if room.APlayerID == -1 then
        room.APlayerID = id
        room.ATeamID = GameRules.CubeGame.Playerid2Teamid[id]
        print('a in ', id)
        return room.APos
    else
        room.BPlayerID = id
        room.BTeamID = GameRules.CubeGame.Playerid2Teamid[id]
        room.IsFull = true
        print('b in ', id)
        return room.BPos
    end
end
--
return m
