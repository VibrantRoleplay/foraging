-----------------
--CleanUp Timer--
-----------------

RegisterNetEvent('foraging:server:CleanUpTimer', function(data)
    local timer = 0

    if Config.CleanUpTimer > data.CooldownInMinutes then
	    timer = data.CooldownInMinutes * 60000
    else
        timer = Config.CleanUpTimer * 60000
    end

    Wait(timer)

    for k, mushroom in pairs(WildMushrooms[data.AreaName]) do
        Wait(500)
        if DoesEntityExist(mushroom) then
            DeleteEntity(mushroom)
        end
    end

    WildMushrooms[data.AreaName] = {}

    for k, nudist in pairs(Nudists[data.AreaName]) do
        Wait(500)
        local nudistEntity = NetworkGetNetworkIdFromEntity(nudist)

        TriggerClientEvent('foraging:client:CleanUpNudists', -1, nudistEntity)
    end

    Nudists[data.AreaName] = {}
end)