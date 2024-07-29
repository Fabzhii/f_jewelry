
local ox_inventory = exports.ox_inventory
local soundid = GetSoundId()
local smokeTable = {}

function insideJewelry(self)
    if IsPedShooting(PlayerPedId()) then 
        ESX.TriggerServerCallback('fjewelry:checkCops', function(xCops)
            ESX.TriggerServerCallback('fjewelry:checkDelay', function(xDelay)
                if xCops >= Config.MinCops and xDelay then 
                    shot()
                end 
            end)
        end)
    end
end


local jewelry = lib.zones.sphere({
    coords = Config.Jewelry.center,
    radius = 20,
    debug = false,
    inside = insideJewelry,
})


function shot()
    hit, endCoords, surfaceNormal, entityHit = RaycastFromPlayer()
    for k,v in pairs(Config.Positions) do 
        if #(endCoords - v.pos) < 1.0 then 

            if not GlobalState.jewelryRobbed then 
                TriggerServerEvent('fjewelry:setRobbed', true)
            end 

            if GlobalState.vitrines[k] == 0 then 
                TriggerServerEvent('fjewelry:changeVitrine', k, 1)
            end 
        end 
    end 
end 

AddStateBagChangeHandler('vitrines', 'global', function()
    Citizen.Wait(50)
    for k,v in pairs(Config.Positions) do 
        if GlobalState.vitrines[k] == 1 then 
            CreateModelSwap(v.pos.x, v.pos.y, v.pos.z, 0.1, GetHashKey(v.startprop), GetHashKey(v.endprop), false)
        elseif GlobalState.vitrines[k] == 0 then 
            RemoveModelSwap(v.pos.x, v.pos.y, v.pos.z, 0.1, GetHashKey(v.startprop), GetHashKey(v.endprop), false )
        end 
    end 
end)

isrobbed = false 
AddStateBagChangeHandler('jewelryRobbed', 'global', function()
    Citizen.Wait(50)
    if GlobalState.jewelryRobbed then 
        isrobbed = true 
        PlaySoundFromCoord(soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", Config.Jewelry.center)

        ESX.TriggerServerCallback('fjewelry:getJob', function(xJob)
            if xJob == Config.PoliceJob then 
                Config.PoliceNitify()
                createPoliceBlip()
            end 
        end)

        for k,v in pairs(Config.Jewelry.smoke) do
            if not HasNamedPtfxAssetLoaded("core") then
                RequestNamedPtfxAsset("core")
                while not HasNamedPtfxAssetLoaded("core") do Wait(1) end
            end
            SetPtfxAssetNextCall("core")
            smokeTable[k] = StartParticleFxLoopedAtCoord("weap_extinguisher", v.pos, v.rotation[1], v.rotation[2], v.rotation[3], 7.0, true, true, true, false)
        end 

        robloop()
    else 
        isrobbed = false 
        StopSound(soundid)

        ESX.TriggerServerCallback('fjewelry:getJob', function(xJob)
            if xJob == Config.PoliceJob then 
                removePoliceBlip()
            end 
        end)

        Citizen.Wait(500)
        for k,v in pairs(smokeTable) do 
            StopParticleFxLooped(v, 0)
        end 
    end 
end)


function RotationToDirection(deg)
    local rad_x = deg['x'] * 0.0174532924
    local rad_z = deg['z'] * 0.0174532924

    local dir_x = -math.sin(rad_z) * math.cos(rad_x)
    local dir_y = math.cos(rad_z) * math.cos(rad_x)
    local dir_z = math.sin(rad_x)
    local dir = vector3(dir_x, dir_y, dir_z)
    return dir
end

function RaycastFromPlayer()
    local hit = false
    local endCoords = nil
    local surfaceNormal = nil
    local entityHit = nil

    local playerPed = PlayerPedId()
    local camCoord = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(0)

    local rayHandle = StartShapeTestRay(camCoord, camCoord + RotationToDirection(camRot) * 1000, -1, playerPed)
    local status, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    return hit, endCoords, surfaceNormal, entityHit
end


Citizen.CreateThread(function()
    jewelryblip = AddBlipForCoord(Config.Jewelry.center)
    SetBlipSprite(jewelryblip, Config.JewelerBlip.Id)
    SetBlipDisplay(jewelryblip, 4)
    SetBlipScale(jewelryblip, 1.0)
    SetBlipColour(jewelryblip, Config.JewelerBlip.Color)
    SetBlipAsShortRange(jewelryblip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.JewelerBlip.Name)
    EndTextCommandSetBlipName(jewelryblip)

    if Config.SellerBlip.Show and Config.Seller.use then 
        jewelryblip = AddBlipForCoord(Config.Seller.pos)
        SetBlipSprite(jewelryblip, Config.SellerBlip.Id)
        SetBlipDisplay(jewelryblip, 4)
        SetBlipScale(jewelryblip, 1.0)
        SetBlipColour(jewelryblip, Config.SellerBlip.Color)
        SetBlipAsShortRange(jewelryblip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.SellerBlip.Name)
        EndTextCommandSetBlipName(jewelryblip)
    end 
end)

local blipRobbery = nil 
function createPoliceBlip()
    pos = Config.Jewelry.center
    blipRobbery = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 1.7)
    SetBlipColour(blipRobbery, 4)
    PulseBlip(blipRobbery)
end 

function removePoliceBlip()
    RemoveBlip(blipRobbery)
end 

function robloop()
    while isrobbed do

        local pedCoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Config.Positions) do 
            if #(pedCoords - v.pos) < 0.9 then 
                if IsControlJustReleased(0, 38) then 
                    if GlobalState.vitrines[k] == 1 then 
                        TriggerServerEvent('fjewelry:changeVitrine', k, 2)

                        SetEntityHeading(PlayerPedId(), GetHeadingFromCoords(pedCoords, v.pos))

                        lib.progressCircle({
                            duration = 3000,
                            position = 'bottom',
                            canCancel = false,
                            anim = {
                                dict = 'mini@repair',
                                clip = 'fixing_a_ped'
                            },
                            disable = {
                                move = true,
                                combat = true,
                                mouse = true,
                            }
                        })

                        TriggerServerEvent('fjewelry:addRandonItem')

                    end 
                end 
            end
        end
        
        Citizen.Wait(1)
    end 
end 

function GetHeadingFromCoords(coord1, coord2)
    local deltaX, deltaY = coord2.x - coord1.x, coord2.y - coord1.y
    local heading = (math.deg(math.atan(deltaY, deltaX)) - 90) % 360
    return heading
end


function enterSeller(self)
    Config.InfoBar(Config.Seller.interact, true)
end
 
function exitSeller(self)
    Config.InfoBar(Config.Seller.interact, false)
end

function insideNearSeller(self)
    if IsControlJustReleased(0, 38) then 
        interactSeller()
    end 
end

local seller_near = lib.zones.sphere({
    coords = Config.Seller.pos,
    radius = 1,
    debug = false,
    onEnter = enterSeller,
    onExit = exitSeller,
    inside = insideNearSeller,
})

function insideSeller(self)
    marker = Config.Seller.marker
    DrawMarker(
        marker.type, Config.Seller.pos, 0.0, 0.0, 0.0, 0.0, 180, 0.0, marker.size, marker.size, marker.size, 
        marker.r,  marker.g,  marker.b, 100, false, true, 2, nil, nil, false
    )
end

local seller_far = lib.zones.sphere({
    coords = Config.Seller.pos,
    radius = 10,
    debug = false,
    inside = insideSeller,
})



function interactSeller()
    local options = {}
    for k,v in pairs(Config.Seller.items) do 
        table.insert(options, {
            type = 'number', label = (v.label..': '..v.price..'$'), icon = 'plus', min = 0, max = GetCount(v.item), default = 0,
        })
    end 

    input = lib.inputDialog(Config.Seller.header, options)
    if input ~= nil then 
        for k,v in pairs(input) do 
            if tonumber(v) > 0 then 
                TriggerServerEvent('fjewelry:removeItem', Config.Seller.items[k].item, tonumber(v), nil)
                TriggerServerEvent('fjewelry:addMoney', Config.Seller.items[k].price * tonumber(v))
            end 
        end 
    end
end 

function GetCount(item)
    local count = 0
    for k,v in pairs(exports.ox_inventory:Items()) do 
        if v.name == item then 
            count = v.count
        end 
    end 
    return(count)
end 