Config = {}

Config.Delay = 30 -- Time in Minutes
Config.PoliceJob = 'police'
Config.MinCops = 1

Config.Jewelry = {
    center = vector3(-622.2536, -230.9609, 38.0570),
    smoke = {
        {pos = vector3(-617.4638, -233.1503, 40.0570), rotation = {88.2073,0,0}},
        {pos = vector3(-622.9080, -225.5833, 40.0570), rotation = {168.1483,0,0}},
    }
}

Config.Seller = {
    use = true,
    pos = vector3(707.2796, -966.6873, 30.4129),
    interact = '[E] - Mit Juwelenverkäufer Interagieren',
    header = 'Juwelen Verkäufer',
    items = {
        {
            item = 'jewel',
            label = 'Juwelen',
            price = 500,
        },
        {
            item = 'clock',
            label = 'Uhr',
            price = 500,
        },
        {
            item = 'diamond',
            label = 'Diamant',
            price = 500,
        },
        {
            item = 'chain',
            label = 'Kette',
            price = 500,
        },
    },
    marker = {
        type = 2,
        size = 0.5,
        r = 118,
        g = 241,
        b = 149,
    }
}


Config.JewelerBlip = {
    Name = 'Juwelier',
    Id = 439,
    Color = 4,
}

Config.SellerBlip = {
    Show = true,
    Name = 'Juwelen Verkäufer',
    Id = 304,
    Color = 40,
}

Config.Items = {
    {
        item = 'jewel',
        count = {1, 6},
        chance = 60,
    },
    {
        item = 'clock',
        count = {1, 2},
        chance = 30,
    },
    {
        item = 'diamond',
        count = {1, 1},
        chance = 10,
    },
    {
        item = 'chain',
        count = {1, 3},
        chance = 40,
    },
}

Config.Positions = {
    {
        pos = vector3(-626.3253, -239.0511, 37.64523),
        endprop = 'des_jewel_cab2_end',
        startprop = 'des_jewel_cab2_start',
    },
    {
        pos = vector3(-625.2751, -238.2881, 37.64523),
        endprop = 'des_jewel_cab3_end',
        startprop = 'des_jewel_cab3_start',
    },
    {
        pos = vector3(-627.2115, -234.8942, 37.64523),
        endprop = 'des_jewel_cab3_end',
        startprop = 'des_jewel_cab3_start',
    },
    {
        pos = vector3(-626.1613, -234.1315, 37.64523),
        endprop = 'des_jewel_cab4_end',
        startprop = 'des_jewel_cab4_start',
    },
    {
        pos = vector3(-626.5439, -233.6047, 37.64523),
        endprop = 'des_jewel_cab_end',
        startprop = 'des_jewel_cab_start',
    },
    {
        pos = vector3(-627.5945, -234.3678, 37.64523),
        endprop = 'des_jewel_cab_end',
        startprop = 'des_jewel_cab_start',
    },
    {
        pos = vector3(-622.6159, -232.5636, 37.64523),
        endprop = 'des_jewel_cab_end',
        startprop = 'des_jewel_cab_start', 
    },
    {
        pos = vector3(-620.5214, -232.8823, 37.64523),
        endprop = 'des_jewel_cab4_end',
        startprop = 'des_jewel_cab4_start',
    },
    {
        pos = vector3(-620.1764, -230.7865, 37.64523),
        endprop = 'des_jewel_cab_end',
        startprop = 'des_jewel_cab_start',
    },
    {
        pos = vector3(-621.5175, -228.9474, 37.64523),
        endprop = 'des_jewel_cab3_end',
        startprop = 'des_jewel_cab3_start', 
    },
    {
        pos = vector3(-623.6147, -228.6247, 37.64523),
        endprop = 'des_jewel_cab2_end',
        startprop = 'des_jewel_cab2_start', 
    },
    {
        pos = vector3(-623.9558, -230.7263, 37.64523),
        endprop = 'des_jewel_cab4_end',
        startprop = 'des_jewel_cab4_start',
    },
    {
        pos = vector3(-619.8483, -234.9137, 37.64523),
        endprop = 'des_jewel_cab_end',
        startprop = 'des_jewel_cab_start',
    },
    {
        pos = vector3(-618.7984, -234.1509, 37.64523),
        endprop = 'des_jewel_cab3_end',
        startprop = 'des_jewel_cab3_start', 
    },
    {
        pos = vector3(-624.2796, -226.6066, 37.64523),
        endprop = 'des_jewel_cab4_end',
        startprop = 'des_jewel_cab4_start',
    },
    {
        pos = vector3(-625.3300, -227.3697, 37.64523),
        endprop = 'des_jewel_cab3_end',
        startprop = 'des_jewel_cab3_start',
    },
    {
        pos = vector3(-619.2031, -227.2482, 37.64523),
        endprop = 'des_jewel_cab2_end',
        startprop = 'des_jewel_cab2_start',
    },
    {
        pos = vector3(-619.9662, -226.198, 37.64523),
        endprop = 'des_jewel_cab_end',
        startprop = 'des_jewel_cab_start',
    },
    {
        pos = vector3(-617.0856, -230.1627, 37.64523),
        endprop = 'des_jewel_cab2_end',
        startprop = 'des_jewel_cab2_start', 
    },
    {
        pos = vector3(-617.8492, -229.1128, 37.64523),
        endprop = 'des_jewel_cab3_end',
        startprop = 'des_jewel_cab3_start',
    },
}


Config.Notifcation = function(notify)
    local message = notify[1]
    local notify_type = notify[2]
    lib.notify({
        position = 'top-right',
        description = message,
        type = notify_type,
    })
end 

Config.InfoBar = function(info, toggle)
    if toggle then 
        lib.showTextUI(info, {position = 'left-center'})
    else 
        lib.hideTextUI()
    end
end 

Config.PoliceNitify = function()
    lib.notify({
        id = 'f_jewelry',
        title = 'Raub in Gange',
        description = 'Es wird gerade der Juwelier ausgeraubt!',
        position = 'bottom',
        icon = 'gem',
    })
end 