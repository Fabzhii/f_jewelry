timecounter = 0

Citizen.CreateThread(function()
    while true do 
        if timecounter == 0 then 
            reset()
        end 
        if timecounter >= 0 then 
            timecounter = timecounter - 1
        end 
        Citizen.Wait(60 * 1000)
    end 
end)

function reset()
    GlobalState.jewelryRobbed = false 

    local vitrines = {}
    for k,v in pairs(Config.Positions) do 
        vitrines[k] = 0
    end 
    GlobalState.vitrines = vitrines
end 

ESX.RegisterServerCallback('fjewelry:checkDelay', function(source, cb)
    if timecounter <= 0 then 
        cb(true)
    else 
        cb(false)
    end 
end)

ESX.RegisterServerCallback('fjewelry:checkCops', function(source, cb)
    local xPlayers = ESX.GetExtendedPlayers('job', 'police')
    cb(#xPlayers)
end)

ESX.RegisterServerCallback('fjewelry:getJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getJob().name)
end)


RegisterServerEvent('fjewelry:changeVitrine')
AddEventHandler('fjewelry:changeVitrine', function(vitrine, state)
    local vitrines = GlobalState.vitrines
    vitrines[vitrine] = state
    GlobalState.vitrines = vitrines
end)

RegisterServerEvent('fjewelry:setRobbed')
AddEventHandler('fjewelry:setRobbed', function(state)
    GlobalState.jewelryRobbed = state
    Citizen.Wait(300 * 1000)
    reset()
    GlobalState.jewelryRobbed = false
    timecounter = Config.Delay
end)


RegisterServerEvent('fjewelry:addRandonItem')
AddEventHandler('fjewelry:addRandonItem', function()
    for k,v in pairs(Config.Items) do 
        if math.random(0, 100) < v.chance then 
            local item = v.item
            local count = math.random(v.count[1], v.count[2])
            if exports.ox_inventory:CanCarryItem(source, item, count, nil) then 
                exports.ox_inventory:AddItem(source, item, count, {stolen = true})
            end 
        end 
    end 
end)

RegisterServerEvent('fjewelry:removeItem')
AddEventHandler('fjewelry:removeItem', function(item, count, metadata)
    exports.ox_inventory:RemoveItem(source, item, count, metadata)
end)

RegisterServerEvent('fjewelry:addMoney')
AddEventHandler('fjewelry:addMoney', function(money)
    exports.ox_inventory:RemoveItem(source, 'money', money, nil)
end)