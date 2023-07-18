local QBCore = exports['qb-core']:GetCoreObject()
local currentPed

Text3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    local model = GetHashKey(Config.ped)
    for _, location in ipairs(Config.washLocations) do
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end
        location.ped = CreatePed(4, model, location.coords.x, location.coords.y, location.coords.z - 1.0, location.coords.w, false, false)
        SetBlockingOfNonTemporaryEvents(location.ped, true)
        FreezeEntityPosition(location.ped, true)
        SetEntityInvincible(location.ped, true)
    end
end)

Citizen.CreateThread(function()
    while true do
        local inRange = false
        local PlayerPos = GetEntityCoords(PlayerPedId())

        for _, location in ipairs(Config.washLocations) do
            local distance = #(PlayerPos - vector3(location.coords.x, location.coords.y, location.coords.z))

            if distance < 5 then
                inRange = true
                Text3D(location.coords.x, location.coords.y, location.coords.z, "[G] Wash Money")
                if distance < 2 and IsControlJustPressed(0, 47) then
                    currentPed = location.ped
                    PlayPedAmbientSpeechWithVoiceNative(currentPed, "GENERIC_HI", Config.pedVoice, "Speech_Params_Standard", 0)
                    TriggerServerEvent("apolo_moneywash:server:checkmoney")
                end
                break
            end
        end

        if not inRange then
            Citizen.Wait(2000)
        end
        Citizen.Wait(3)
    end
end)

RegisterNetEvent('apolo_moneywash:client:WashProggress')
AddEventHandler('apolo_moneywash:client:WashProggress', function()
    QBCore.Functions.Progressbar("wash_money", "Washing Money...", Config.washTime(), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = Config.washAnimation.dict,
            anim = Config.washAnimation.anim,
            flags = 1,
        }, Config.washAnimation.prop, {}, function() -- Done
            StopAnimTask(PlayerPedId(), Config.washAnimation.dict, Config.washAnimation.anim, 1.0)
            TriggerServerEvent("apolo_moneywash:server:getmoney")
            PlayPedAmbientSpeechWithVoiceNative(currentPed, "GENERIC_THANKS", Config.pedVoice, "Speech_Params_Standard", 0)
        end, function() -- Cancel
            StopAnimTask(PlayerPedId(), Config.washAnimation.dict, Config.washAnimation.anim, 1.0)
            QBCore.Functions.Notify("Canceled..", "error")
            PlayPedAmbientSpeechWithVoiceNative(currentPed, "GENERIC_INSULT_MED", Config.pedVoice, "Speech_Params_Standard", 0)
        end
    )
end)
