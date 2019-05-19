local m = {}
local MAX_ROOM_NUM = 9
local Room = {
    [1] = {};
    [2] = {};
    [3] = {};
    [4] = {};
    [5] = {};
    [6] = {};
    [7] = {};
    [8] = {};
    [9] = {};
}

function m.InitRoomData()
    
    local RoomData = LoadKeyValues("scripts/kv/RoomData.kv");
    
    for i = 1, MAX_ROOM_NUM do
        Room[i].IsFull = false;
        Room[i].Type = RoomData[tostring(i)]["Type"];
        Room[i].AID = 0;
        Room[i].BID = 0;
        Room[i].APos = Vector(RoomData[tostring(i)]["A_X"], RoomData[tostring(i)]["A_Y"], RoomData[tostring(i)]["A_Z"]);
        Room[i].BPos = Vector(RoomData[tostring(i)]["B_X"], RoomData[tostring(i)]["B_Y"], RoomData[tostring(i)]["B_Z"]);
    -- print("room", i, Room[i].IsFull, Room[i].AID, Room[i].APos);
    end
end

function m.ClearAllRoomData()
    for i = 1, MAX_ROOM_NUM do
        Room[i].IsFull = false;
        Room[i].AID = 0;
        Room[i].BID = 0;
    end
end

function m.GetRoomData(k)
    if k <= MAX_ROOM_NUM then
        return Room[k];
    end
end

local TypeNum = {
    ["Strength"] = {1, 4, 7},
    ["Agility"] = {2, 5, 8},
    ["Intelligence"] = {3, 6, 9}
}
function m.FindEmptyRoomPos(id, t)
    if t == nil then
        local ta = MathNumber.GetRandomNumList(MAX_ROOM_NUM);
        for _, v in pairs(ta) do
            if not Room[v].IsFull then
                return m.SetRoomId(Room[v], id);
            end
        end
    else
        local ta = MathNumber.GetRandomNumList(3);
        -- print("---start----", table.print(ta), "---end----");
        for _, v in pairs(ta) do
            -- print("value", v, TypeNum[t][v]);
            if not Room[TypeNum[t][v]].IsFull then
                return m.SetRoomId(Room[TypeNum[t][v]], id);
            end
        end
    end
end

function m.SetRoomId(room, id)
    if room.AID == 0 then
        room.AID = id;
        -- print("a in ", id)
        return room.APos;
    else
        room.BID = id;
        room.IsFull = true;
        -- print("b in ", id)
        return room.BPos;
    end
end
--
return m;
