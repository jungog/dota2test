local m = {}

function m.GetRandomNumList(len)
    local rsList = {}
    for i = 1, len do
        table.insert(rsList, i)
    end
    local num, tmp
    for i = 1, len do
        num = math.random(1, len)
        tmp = rsList[i]
        rsList[i] = rsList[num]
        rsList[num] = tmp
    end
    return rsList
end

return m;
