local QBCore = exports['qb-core']:GetCoreObject()

local Listings = {}

-- Load listings on server start (optional: you can load from DB)
CreateThread(function()
    -- For demo, start empty or you can load saved listings from DB here
    Listings = {}
end)

-- Client requests current listings
RegisterNetEvent('IFFIx_realtor:server:RequestListings', function()
    local src = source
    TriggerClientEvent('IFFIx_realtor:client:UpdateListings', src, Listings)
end)

-- Realtor adds a listing (example)
RegisterNetEvent('IFFIx_realtor:server:AddListing', function(listing)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        -- Basic validation
        if listing.address and listing.price then
            listing.owner = Player.PlayerData.citizenid
            table.insert(Listings, listing)
            TriggerClientEvent('QBCore:Notify', src, "Listing added!", "success")
            -- Notify all clients of updated listings
            TriggerClientEvent('IFFIx_realtor:client:UpdateListings', -1, Listings)
        else
            TriggerClientEvent('QBCore:Notify', src, "Invalid listing data!", "error")
        end
    end
end)

-- Player tries to buy a house via realtor
RegisterNetEvent('IFFIx_realtor:server:PurchaseHouse', function(houseId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local houseIndex = nil

    for i, listing in ipairs(Listings) do
        if listing.id == houseId then
            houseIndex = i
            break
        end
    end

    if houseIndex then
        local listing = Listings[houseIndex]
        if Player.Functions.RemoveMoney('bank', listing.price) then
            -- Transfer ownership, update DB as needed
            -- Example: Update house owner
            MySQL.Async.execute("UPDATE IFFIx_houses SET owner = @owner WHERE id = @id", {
                ['@owner'] = Player.PlayerData.citizenid,
                ['@id'] = listing.id
            })
            -- Remove listing from realtor list
            table.remove(Listings, houseIndex)
            TriggerClientEvent('QBCore:Notify', src, "House purchased via realtor!", "success")
            TriggerClientEvent('IFFIx_realtor:client:UpdateListings', -1, Listings)
        else
            TriggerClientEvent('QBCore:Notify', src, "Insufficient funds!", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Listing not found!", "error")
    end
end)
