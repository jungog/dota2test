---------------------------------------------------------------------------------
-- 注册UI js发来的事件的监听
---------------------------------------------------------------------------------
function CubeGame:RegisterUIEventListeners()
    CustomGameEventManager:RegisterListener(
        'Hero_Lock',
        function(_, keys)
            self:Lock(keys)
        end
    )

    CustomGameEventManager:RegisterListener(
        'Hero_Select',
        function(_, keys)
            self:Select(keys)
        end
    )
end

function CubeGame:Lock(keys)
end

function CubeGame:Select(keys)
end
