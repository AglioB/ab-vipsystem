Config = {}

Config.Ranks = {
    [1] = { -- Identifier of the lowest VIP rank.
        name = 'silver',    -- Name of the VIP, used to grant VIPs to users.
        label = 'Vip silver', -- Name of the VIP displayed on the screen.
    },
    [2] = { -- Identifier of the next VIP rank.
        name = 'gold',
        label = 'Vip gold',
    },
    [3] = { -- Identifier of the highest VIP rank.
        name = 'diamond',
        label = 'Vip diamond',
    },
    -- More VIP ranks can be added, ensuring the hierarchy is maintained using numbers as identifiers.
}

Config.AllowPermanentVips = true -- If this option is true, it enables the possibility to grant permanent VIPs to users.

Config.Admin = 'god' -- Defines the required rank to access the VIP administration menu.

-- These are the notification types. You can customize them according to your needs.
Config.NotifyType = {
    error = 'error',
    success = 'success'
}

Config.CheckVips = true -- If this option is true, the system will periodically check the expiration date of VIPs and remove those that have expired.

Config.CheckVipsInterval = 30 * 1000 -- This is the time interval in milliseconds to check VIPs. It is only activated if Config.CheckVips is true.
