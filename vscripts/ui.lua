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
    CustomGameEventManager:RegisterListener(
        'Select_Hero',
        function(_, keys)
            self:SelectHero(keys)
        end
    )
    CustomGameEventManager:RegisterListener("Add_Bot", function(_, keys) end)
end

function CubeGame:LockHero(keys)
end

function CubeGame:SelectHero(keys)
end

function CubeGame:AddBot(keys)
    local hostPlayerId = keys.PlayerID
    if GameRules:PlayerHasCustomGameHostPrivileges(PlayerResource:GetPlayer(hostPlayerId)) then
        local playerCount = PlayerResource:GetPlayerCount()
        if (playerCount >= 8) then
            return
        end
        local botPlayerId = playerCount
        
        local addSuccess = Tutorial:AddBot("", "", "", false)
        
        if (addSuccess ~= true) then
            return
        end
        local player = PlayerResource:GetPlayer(botPlayerId)
        if player ~= nil then
            for i = 1, #AllTeamIdx do
                if (PlayerResource:GetPlayerCountForTeam(AllTeamIdx[i]) == 0) then
                    PlayerResource:SetCustomTeamAssignment(botPlayerId, AllTeamIdx[i])
                    
                    GameRules.DW.PlayerList[botPlayerId].IsEmpty = false
                    GameRules.DW.PlayerList[botPlayerId].PlayerName = tostring(PlayerResource:GetPlayerName(botPlayerId))
                    GameRules.DW.PlayerList[botPlayerId].IsOnline = true
                    GameRules.DW.PlayerList[botPlayerId].IsBot = true
                    -- GameRules.DW.PlayerList[botPlayerId].MaxSupply = GameRules.DW.GetMaxSupply(botPlayerId)
                    -- GameRules.DW.PlayerList[botPlayerId].CurrentSupply = GameRules.DW.GetCurrentSupply(botPlayerId)
                    
                    -- ShowPlayerMessage(GameRules.DW.PlayerList[botPlayerId].PlayerName .. " HAS JOINED THE GAME", player)
                    break
                end
            end
        end
    end
end
