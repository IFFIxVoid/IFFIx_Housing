Config = {}

-- Housing config
Config.Housing = {
    Shells = {
        "shell_prop1",
        "shell_prop2",
        "shell_mlo1",
        "shell_mlo2",
    },
    SqlTable = 'IFFIx_houses',
    MaxStorageSlots = 50,
    DefaultPrice = 100000,
    -- Add other housing configs as needed
}

-- Realtor config
Config.Realtor = {
    MaxListings = 10,
    ListingExpireTime = 604800, -- 7 days in seconds
}
