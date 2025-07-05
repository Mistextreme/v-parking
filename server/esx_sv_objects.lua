local ESX = exports["es_extended"]:getSharedObject()

local Objects = {}

local function CreateObjectId()
    local objectId = math.random(10000, 99999)
    while Objects[objectId] do
        objectId = math.random(10000, 99999)
    end
    return objectId
end

function table.contains(tbl, val)
    for _, v in pairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

if Config.UseObjectPlacer then
    ESX.RegisterCommand(Config.ObjectMenuCommand, 'user', function(xPlayer, args, showError)
        local jobName = xPlayer.job.name
        
        if table.contains(Config.ParkingJobs, jobName) and xPlayer.job.onduty then
            TriggerClientEvent('parking:OpenObjectMenu', xPlayer.source)
        else
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {
                title = Lang.Lang['access_denied_title'],
                description = Lang.Lang['access_denied_description'],
                type = 'error'
            })
        end
    end, false, {
        help = Lang.Lang['object_menu_command']
    })
end

RegisterNetEvent('parking:spawnObject', function(object, loc, heading)
    print('Server spawnObject triggered with:', object, loc, heading)
    local objectId = CreateObjectId()
    local type = object
    Objects[objectId] = type
    TriggerClientEvent("parking:spawnObject", -1, objectId, type, loc, heading)
    TriggerClientEvent('ox_lib:notify', -1, {
        title = Lang.Lang['success'],
        description = Lang.Lang['object_spawn'],
        type = 'success'
    })
end)

RegisterNetEvent('parking:deleteObject', function(objectId)
    TriggerClientEvent('parking:removeObject', -1, objectId)
    TriggerClientEvent('ox_lib:notify', -1, {
        title = Lang.Lang['success'],
        description = Lang.Lang['object_deleted'],
        type = 'success'
    })
end)