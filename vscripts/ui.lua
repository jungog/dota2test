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
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 1)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 1)
        local playerCount = PlayerResource:GetPlayerCount()
        if (playerCount >= 6) then
            return
        end
        local botPlayerId = playerCount
        
        local addSuccess = Tutorial:AddBot("", "", "", false)
        
        if (addSuccess ~= true) then
            return
        end

        local player = PlayerResource:GetPlayer(botPlayerId)     
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
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 0)
        GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)
    end
end
