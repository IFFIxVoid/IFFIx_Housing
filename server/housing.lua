local QBCore = exports['qb-core']:GetCoreObject()

local Houses = {}

-- Load houses from database on server start using oxmysql
CreateThread(function()
    local result = exports.oxmysql:executeSync("SELECT * FROM IFFIx_houses")
    if result then
        for _, house in pairs(result) do
            Houses[house.id] = house
        end
    end
end)

-- Provide houses to clients on request
RegisterNetEvent('IFFIx_housing:server:RequestHouses', function()
    local src = source
    TriggerClientEvent('IFFIx_housing:client:ReceiveHouses', src, Houses)
end)

-- Handle purchase request
RegisterNetEvent('IFFIx_housing:server:BuyHouse', function(houseId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local house = Houses[houseId]

    if house then
        if not house.owner then
            if Player.Functions.RemoveMoney('bank', house.price) then
                house.owner = Player.PlayerData.citizenid
                -- Update DB using oxmysql
                exports.oxmysql:execute("UPDATE IFFIx_houses SET owner = @owner WHERE id = @id", {
                    ['@owner'] = house.owner,
                    ['@id'] = houseId
                })
                TriggerClientEvent('QBCore:Notify', src, "House purchased!", "success")
            else
                TriggerClientEvent('QBCore:Notify', src, "You don't have enough money!", "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "House already owned!", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "House not found!", "error")
    end
end)
