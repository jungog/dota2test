---------------------------------------------------------------------------------
-- 注册UI js发来的事件的监听
---------------------------------------------------------------------------------
function CubeGame:RegisterUIEventListeners()
    CustomGameEventManager:RegisterListener(
        'Lock_Hero',
        function(_, keys)
            self:LockHero(keys)
        end
    )
    CustomGameEventManager:RegisterListener('Select_Hero',
        function(_, keys)
            self:SelectHero(keys) end)
    CustomGameEventManager:RegisterListener("ADD_BOT", function(_, keys)self:AddBot(keys) end)
end

function CubeGame:LockHero(keys)
end

function CubeGame:SelectHero(keys)
end

function CubeGame:AddBot(keys)
    print("re addbot")
    table.print(keys);
    local hostPlayerId = keys.PlayerID
    if GameRules:PlayerHasCustomGameHostPrivileges(PlayerResource:GetPlayer(hostPlayerId)) then
        local playerCount = PlayerResource:GetPlayerCount()
        if (playerCount >= 8) then
            return
        end
        local botPlayerId = playerCount
        
        local addSuccess = Tutorial:AddBot("npc_dota_hero_wisp", "", "", false)
        
        if (addSuccess ~= true) then
            return
        end
        print("re addbot botPlayerId", botPlayerId)
        local player = PlayerResource:GetPlayer(botPlayerId)
        print("player ~= nil ", player)
        
        for i = 0, 10 do
            local player = PlayerResource:GetPlayer(i)
            print("what", i, player)
            if player ~= nil then
                table.print(player)
                print("name ", tostring(PlayerResource:GetPlayerName(i)));
            end
        end
        
        
        
        if player ~= nil then
            print("player ~= nil ")
            for i = 1, #AllTeamIdx do
                print("player ~= nil ", i)
                if (PlayerResource:GetPlayerCountForTeam(AllTeamIdx[i]) == 0) then
                    print("re addbot ", i, AllTeamIdx[i])
                    PlayerResource:SetCustomTeamAssignment(botPlayerId, AllTeamIdx[i])
                    
                    GameRules.CubeGame.PlayerList[botPlayerId].IsEmpty = false
                    GameRules.CubeGame.PlayerList[botPlayerId].PlayerName = tostring(PlayerResource:GetPlayerName(botPlayerId))
                    GameRules.CubeGame.PlayerList[botPlayerId].IsOnline = true
                    GameRules.CubeGame.PlayerList[botPlayerId].IsBot = true
                    -- GameRules.DW.PlayerList[botPlayerId].MaxSupply = GameRules.DW.GetMaxSupply(botPlayerId)
                    -- GameRules.DW.PlayerList[botPlayerId].CurrentSupply = GameRules.DW.GetCurrentSupply(botPlayerId)
                    break
                end
            end
        end
    end
end
