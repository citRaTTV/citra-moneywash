-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local pedEntity, blip, coords = 0, 0, vector4(0, 0, 0, 0)

-- Functions
local function teardownPed()
    if pedEntity ~= 0 then
        exports['qb-target']:RemoveTargetEntity(pedEntity)
        TaskWanderStandard(pedEntity, 10.0, 10)
        SetEntityAsNoLongerNeeded(pedEntity)
        RemoveBlip(blip)
    end
end

local function updateBlip()
    if not Config.blipEnabled then return end
    local PlayerData = QBCore.Functions.GetPlayerData()

    if PlayerData.job.type ~= 'leo' then
        blip = AddBlipForCoord(coords.xyz)
        SetBlipSprite(blip, 456)
        SetBlipColour(blip, 79)
        SetBlipScale(blip, 1.0)
        SetBlipDisplay(blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName("Shady person")
        EndTextCommandSetBlipName(blip)
    end
end

local function spawnPed(_coords)
    teardownPed()

    local model = joaat(Config.ped)
    coords = _coords

    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
    end
    pedEntity = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
    SetBlockingOfNonTemporaryEvents(pedEntity, true)
    FreezeEntityPosition(pedEntity, true)
    SetEntityInvincible(pedEntity, true)

    exports['qb-target']:AddTargetEntity(pedEntity, {
        options = {
            {
                label = 'Wash money',
                action = function(entity)
                    local PlayerData = QBCore.Functions.GetPlayerData()

                    if PlayerData.job.type == 'leo' then
                        QBCore.Functions.Notify("I don't talk to cops yo!", 'error')
                    else
                        PlayPedAmbientSpeechWithVoiceNative(pedEntity, "GENERIC_HI", Config.pedVoice, "Speech_Params_Standard", 0)
                        TriggerServerEvent("citra-moneywash:server:checkmoney")
                    end
                end,
            },
        },
        distance = 2.0,
    })

    updateBlip()
end

-- Events
RegisterNetEvent('citra-moneywash:client:WashProgress', function()
    QBCore.Functions.Progressbar("wash_money", "Washing Money...", Config.washTime(), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = Config.washAnimation.dict,
            anim = Config.washAnimation.anim,
            flags = 1,
        }, {}, {}, function() -- Done
            StopAnimTask(PlayerPedId(), Config.washAnimation.dict, Config.washAnimation.anim, 1.0)
            TriggerServerEvent("citra-moneywash:server:getmoney")
            PlayPedAmbientSpeechWithVoiceNative(pedEntity, "GENERIC_THANKS", Config.pedVoice, "Speech_Params_Standard", 0)
        end, function() -- Cancel
            StopAnimTask(PlayerPedId(), Config.washAnimation.dict, Config.washAnimation.anim, 1.0)
            QBCore.Functions.Notify("Canceled..", "error")
            PlayPedAmbientSpeechWithVoiceNative(pedEntity, "GENERIC_INSULT_MED", Config.pedVoice, "Speech_Params_Standard", 0)
        end
    )
end)

RegisterNetEvent('citra-moneywash:client:UpdateLocation', function(_coords)
    spawnPed(_coords)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(_)
    updateBlip()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        QBCore.Functions.TriggerCallback('citra-moneywash:server:GetCurCoords', function(_coords)
            spawnPed(_coords)
        end)
    end
end)
