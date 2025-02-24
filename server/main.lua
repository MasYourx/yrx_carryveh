ESX = exports["es_extended"]:getSharedObject()

local accessLevel = 'admin' -- set to 'admin' for admin only access. set to 'all' for everyone can access the commands

ESX.RegisterServerCallback('checkAdminPermission', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if accessLevel == 'all' then
        cb(true)
    elseif xPlayer and xPlayer.getGroup() == accessLevel then
        cb(true)
    else
        cb(false)
    end
end)
