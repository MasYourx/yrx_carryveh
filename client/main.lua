ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(0)
    end
end)

local carryingVehicle = false
local carriedVehicle = nil

function CarryVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 71) -- Vehicle Radius
    
    if vehicle and DoesEntityExist(vehicle) then
        if carryingVehicle then
            lib.notify({
                title = 'Carry Vehicle',
                description = 'Kamu sudah membawa kendaraan!',
                type = 'error'
            })
            return
        end

        -- Start Anim
        RequestAnimDict('anim@heists@box_carry@')
        while not HasAnimDictLoaded('anim@heists@box_carry@') do
            Wait(100)
        end
        TaskPlayAnim(playerPed, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 49, 0, false, false, false)
        AttachEntityToEntity(vehicle, playerPed, GetPedBoneIndex(playerPed, 560309), -- Attach to Bone : Hand
            0.0, 2.5, 0.5,   -- vehicle pos
            0.0, 0.0, 0.0,
            true, true, false, true, 1, true)

        carryingVehicle = true
        carriedVehicle = vehicle

        lib.notify({
            title = 'Carry Vehicle',
            description = 'Kamu mengangkat kendaraan!',
            type = 'success'
        })
    else
        lib.notify({
            title = 'Carry Vehicle',
            description = 'Tidak ada kendaraan di dekatmu!',
            type = 'error'
        })
    end
end

function DropVehicle()
    if carryingVehicle and carriedVehicle then
        DetachEntity(carriedVehicle, true, true)
        ClearPedTasksImmediately(PlayerPedId()) -- Stop anim
        carryingVehicle = false
        carriedVehicle = nil

        lib.notify({
            title = 'Carry Vehicle',
            description = 'Kamu meletakkan kendaraan!',
            type = 'success'
        })
    else
        lib.notify({
            title = 'Carry Vehicle',
            description = 'Kamu tidak sedang membawa kendaraan!',
            type = 'error'
        })
    end
end

RegisterCommand('carryvehicle', function()
    ESX.TriggerServerCallback('checkAdminPermission', function(hasPermission)
        if hasPermission then
            CarryVehicle()
        else
            lib.notify({
                title = 'Carry Vehicle',
                description = 'Access Denied!',
                type = 'error'
            })
        end
    end)
end, false)

RegisterCommand('dropvehicle', function()
    ESX.TriggerServerCallback('checkAdminPermission', function(hasPermission)
        if hasPermission then
            DropVehicle()
        else
            lib.notify({
                title = 'Carry Vehicle',
                description = 'Access Denied!',
                type = 'error'
            })
        end
    end)
end, false)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if carryingVehicle and carriedVehicle then
        DetachEntity(carriedVehicle, true, true)
        carryingVehicle = false
        carriedVehicle = nil
        ClearPedTasksImmediately(PlayerPedId())
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if carryingVehicle and carriedVehicle then
        DetachEntity(carriedVehicle, true, true)
        carryingVehicle = false
        carriedVehicle = nil
        ClearPedTasksImmediately(PlayerPedId())
    end
end)