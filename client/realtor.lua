local QBCore = exports['qb-core']:GetCoreObject()

local CurrentListings = {}

-- Open realtor menu
RegisterNetEvent('IFFIx_realtor:client:OpenMenu', function()
    -- Show UI or menu for realtor listings
    OpenRealtorMenu()
end)

function OpenRealtorMenu()
    -- Example menu logic - replace with your UI framework
    local menuItems = {}
    for _, listing in pairs(CurrentListings) do
        table.insert(menuItems, {
            title = listing.address,
            description = "$" .. listing.price,
            onSelect = function()
                AttemptPurchase(listing.id)
            end
        })
    end

    -- This is a placeholder print, replace with actual menu UI
    print("Realtor Listings:")
    for i, item in ipairs(menuItems) do
        print(i .. ". " .. item.title .. " - " .. item.description)
    end
end

function AttemptPurchase(houseId)
    TriggerServerEvent('IFFIx_realtor:server:PurchaseHouse', houseId)
end

-- Receive updated listings from server
RegisterNetEvent('IFFIx_realtor:client:UpdateListings', function(listings)
    CurrentListings = listings
end)

-- Request listings when resource starts
CreateThread(function()
    while not QBCore do Wait(100) end
    TriggerServerEvent('IFFIx_realtor:server:RequestListings')
end)
