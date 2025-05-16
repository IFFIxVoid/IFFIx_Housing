local QBCore = exports['qb-core']:GetCoreObject()

local CurrentHouse = nil
local IsInHouse = false
local HousingBlips = {}

-- Event: Enter house
RegisterNetEvent('IFFIx_housing:client:EnterHouse', function(house)
    if not IsInHouse then
        CurrentHouse = house
        IsInHouse = true
        -- Load house shell or MLO
        LoadHouseShell(house)
        -- Teleport player inside
        EnterHouse(house)
        QBCore.Functions.Notify("Entered house: " .. house.address, "success")
    end
end)

-- Event: Exit house
RegisterNetEvent('IFFIx_housing:client:ExitHouse', function()
    if IsInHouse then
        IsInHouse = false
        -- Teleport player outside
        ExitHouse(CurrentHouse)
        CurrentHouse = nil
        QBCore.Functions.Notify("Exited house", "success")
    end
end)

function LoadHouseShell(house)
    local shell = house.shell or "shell_prop1"
    -- logic to load shell or MLO for the house, placeholder example:
    print("Loading shell: " .. shell)
    -- Add your shell or MLO loading logic here
end

function EnterHouse(house)
    -- Placeholder teleport inside the house
    -- You might want to teleport to a saved interior coord for the shell
    local coords = house.interiorCoords or vector3(0.0, 0.0, 0.0)
    SetEntityCoords(PlayerPedId(), coords)
end

function ExitHouse(house)
    -- Placeholder teleport outside the house
    local coords = house.exitCoords or vector3(0.0, 0.0, 0.0)
    SetEntityCoords(PlayerPedId(), coords)
end

-- Example: Load houses on resource start
CreateThread(function()
    while not QBCore do Wait(100) end
    TriggerServerEvent('IFFIx_housing:server:RequestHouses')
end)

-- Receive house list from server
RegisterNetEvent('IFFIx_housing:client:ReceiveHouses', function(houses)
    -- create blips or markers for houses
    for _, house in pairs(houses) do
        if not HousingBlips[house.id] then
            local blip = AddBlipForCoord(house.position.x, house.position.y, house.position.z)
            SetBlipSprite(blip, 40)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("House: " .. house.address)
            EndTextCommandSetBlipName(blip)
            HousingBlips[house.id] = blip
        end
    end
end)
