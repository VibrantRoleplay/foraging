-----------------
--Ped Variables--
-----------------

Nudists = {
    AlreadySpoke = false,
}

--------------------
--Ped Spawn Thread--
--------------------

CreateThread(function()
    lib.requestModel(Config.DealerPed.PedModel)
    dealer = CreatePed(1, Config.DealerPed.PedModel, Config.DealerPed.Location, true, true)
    SetEntityInvincible(dealer, true)
    SetBlockingOfNonTemporaryEvents(dealer, true)
    FreezeEntityPosition(dealer, true)

    exports.ox_target:addSphereZone({
        coords = vec3(Config.DealerPed.Location.x, Config.DealerPed.Location.y, Config.DealerPed.Location.z+1),
        radius = 1,
        debug = Config.Debug,
        options = {
            {
                icon = "fa-solid fa-comment-dots",
                iconColor = "green",
                label = "Speak to Groovy dude",
                event = 'foraging:client:MushroomMenu',
                distance = 2,
                args = Config.DealerPed.ShopInfo,
            },
        },
    })
end)

-----------------------
--Nudist Spawn Events--
-----------------------

RegisterNetEvent('foraging:client:NudistSpawn', function(data)
    for i = 1, data.NudistInfo.AmountOfNudists do
        local randomCoords = getRandomPointInArea(data.AreaCoords, data.AreaRadius)
        local ground, zCoord = GetGroundZFor_3dCoord(randomCoords.x, randomCoords.y, randomCoords.z, 0)

        Wait(1000)
        nudistPed = CreatePed(1, data.NudistInfo.NudistModel, randomCoords.x, randomCoords.y, zCoord, true, true)
        SetBlockingOfNonTemporaryEvents(nudistPed, true)
        SetEntityInvincible(nudistPed, true)
        TaskWanderInArea(nudistPed, randomCoords.x, randomCoords.y, zCoord, data.AreaRadius, 15, 2.0)

        Nudists[nudistPed] = {
            AlreadySpoke = false,
        }

        local entityTarget = exports.ox_target:addLocalEntity(nudistPed, {
            {
                icon = 'fas fa-shopping-basket',
                label = "Speak to Nudist",
                onSelect = function(args)
                    TriggerEvent('foraging:client:SpeakToNudist', args)
                end,
                iconColor = "green",
                distance = 1.5
            }
		})
    end
end)

RegisterNetEvent('foraging:client:SpeakToNudist', function(data)
    if not Nudists[data.entity].AlreadySpoke then
        lib.notify({
            title = 'Hello',
            description = "Hi there! Wonderful day for some foraging, eh?",
            type = 'success',
        })
        Nudists[data.entity] = {
            AlreadySpoke = true,
        }
    else
        lib.notify({
            title = 'Busy',
            description = "We already spoke ... don't you remember?",
            type = 'attention',
        })
    end
end)