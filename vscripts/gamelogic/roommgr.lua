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
        Room[i].AID = -1
        Room[i].BID = -1
        Room[i].APos = Vector(RoomData[tostring(i)]['A_X'], RoomData[tostring(i)]['A_Y'], RoomData[tostring(i)]['A_Z'])
        Room[i].BPos = Vector(RoomData[tostring(i)]['B_X'], RoomData[tostring(i)]['B_Y'], RoomData[tostring(i)]['B_Z'])
    -- print("room", i, Room[i].IsFull, Room[i].AID, Room[i].APos);
    end
end

function m.ClearAllRoomData()
    for i = 1, MAX_ROOM_NUM do
        Room[i].IsFull = false
        Room[i].AID = -1
        Room[i].BID = -1
    end
end

function m.GetRoomDataIndex(k)
    if k <= MAX_ROOM_NUM then
        return Room[k]
    end
end

function m.GetEnemyPosById(id)
    for i = 1, MAX_ROOM_NUM do
        if Room[i].AID == id then
            return Room[i].BPos
        end
        if Room[i].BID == id then
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
function m.SetEmptyRoomPos(id, t)
    if t == nil then
        
        local ta = MathNumber.GetRandomNumList(MAX_ROOM_NUM)
        print("t==nil")
        table.print(ta);
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
        if Room[i].AID == id or Room[i].BID == id then
            return Room[i].Type
        end
    end
end

function m.GetSelfPosByPlayerId(id)
    for i = 1, MAX_ROOM_NUM do
        if Room[i].AID == id then
            return Room[i].APos
        end
        if Room[i].BID == id then
            return Room[i].BPos
        end
    end
end

function m.GetEnemyPosByPlayerId(id)
    for i = 1, MAX_ROOM_NUM do
        if Room[i].AID == id then
            return Room[i].BPos
        end
        if Room[i].BID == id then
            return Room[i].APos
        end
    end
end

function m.LoadEnemyInSingleRoom(round, teamid)
    for i = 1, MAX_ROOM_NUM do
        if Room[i].IsFull == false then
            if Room[i].AID ~= -1 then
                Enemy.SpawnEnemyByPos(round, teamid, Room[i].BPos, Room[i].APos)
            elseif Room[i].BID ~= -1 then
                Enemy.SpawnEnemyByPos(round, teamid, Room[i].APos, Room[i].BPos)
            end
            Room[i].IsFull = true
        end
    end
end

--内部函数--
function m.SetRoomId(room, id)
    if room.AID == -1 then
        room.AID = id
        print('playerid:', id,"in a")
        return room.APos
    else
        room.BID = id
        room.IsFull = true
        print('playerid:', id,"in b")
        return room.BPos
    end
end
--
return m
