-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local washTracker, lastWash, curCoords, checkingTime = {}, 0, vector4(0, 0, 0, 0), false

-- Functions
local function getWashed(Player)
    return (washTracker[Player.PlayerData.citizenid] and washTracker[Player.PlayerData.citizenid] or 0)
end

local function washMoney(worth, Player)
    local cashAmount = worth * Config.payoutPercentage
    local alreadyWashed = getWashed(Player)
    washTracker[Player.PlayerData.citizenid] = alreadyWashed + worth
    Player.Functions.AddMoney("cash", cashAmount)
    TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, "You washed $"..worth.." of Marked Money! After my cut, here's $"..cashAmount)
    print('Citizen ' .. Player.PlayerData.citizenid .. ' has washed $' .. washTracker[Player.PlayerData.citizenid] .. ' today.')
end

-- Events
RegisterServerEvent('citra-moneywash:server:getmoney')
AddEventHandler('citra-moneywash:server:getmoney', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(tonumber(src))
    local alreadyWashed = getWashed(Player)

    if Player.PlayerData.items ~= nil then
        for slot, item in pairs(Player.PlayerData.items) do
            if item.name == "markedbills" and type(item.info) ~= 'string' and tonumber(item.info.worth) and alreadyWashed + tonumber(item.info.worth) <= Config.maxLaunderedPerCycle then
                Player.Functions.RemoveItem("markedbills", 1, slot)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], "remove")
                washMoney(tonumber(item.info.worth), Player)
                break
            elseif item.name == "markedcash" and item.amount >= 1 then
                local amount = (item.amount + alreadyWashed > Config.maxLaunderedPerCycle) and Config.maxLaunderedPerCycle - alreadyWashed or item.amount
                Player.Functions.RemoveItem("markedcash", amount, slot)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedcash'], "remove")
                washMoney(amount, Player)
                break
            end
        end
    end
end)

RegisterServerEvent('citra-moneywash:server:checkmoney')
AddEventHandler('citra-moneywash:server:checkmoney', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local alreadyWashed = getWashed(Player)
    local hasMarked = false

    if alreadyWashed >= Config.maxLaunderedPerCycle then
        TriggerClientEvent('QBCore:Notify', src, "Listen, I've already washed a bunch of cash for you. Come back later.", 'error')
    elseif Player.PlayerData.items ~= nil then
        for _, item in pairs(Player.PlayerData.items) do
            if (item.name == "markedbills" and type(item.info) ~= 'string' and tonumber(item.info.worth) and (
                    tonumber(item.info.worth) + alreadyWashed <= Config.maxLaunderedPerCycle)) or (item.name == "markedcash" and item.amount >= 1) then
                hasMarked = true
                break
            end
        end

        if hasMarked then
            lastWash = GetGameTimer()
            TriggerClientEvent('citra-moneywash:client:WashProgress', src)

            if checkingTime then return end

            CreateThread(function()
                checkingTime = true
                while (GetGameTimer() - lastWash) < (1 * 60 * 1000) do
                    Wait(10000)
                end
                checkingTime = false
                lastWash = 0

                local newCoords = Config.washLocations[math.random(#Config.washLocations)]
                while newCoords == curCoords do
                    newCoords = Config.washLocations[math.random(#Config.washLocations)]
                    Wait(1)
                end

                curCoords = newCoords
                TriggerClientEvent('citra-moneywash:client:UpdateLocation', -1, curCoords)
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, "You do not have marked money or I've already washed too much for you", 'error')
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        exports['qb-core']:AddItem('markedcash', Config.markedCash)
        QBCore.Functions.CreateUseableItem('markedbills', function(source, item)
            local Player = QBCore.Functions.GetPlayer(source)

            if Player.Functions.GetItemByName(item.name) and type(item.info) ~= "string" and tonumber(item.info.worth) then
                local amount = tonumber(item.info.worth)
                Player.Functions.RemoveItem(item.name, 1, item.slot)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['markedbills'], "remove")
                Player.Functions.AddItem('markedcash', amount)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['markedcash'], "add")
            end
        end)

        curCoords = Config.washLocations[math.random(#Config.washLocations)]
    end
end)

-- Callbacks
QBCore.Functions.CreateCallback('citra-moneywash:server:GetCurCoords', function(source, cb)
    cb(curCoords)
end)
