local Sleep, Drug, Ped, TakingDrugs, SkillSet = 1100, nil, nil, false, {'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'hard'}
ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

DrawText3D = function(coords, text)
    local paskaa = coords - vector3(0.0, 0.0, -0.25)
    local TextLen =  0.015 + text:gsub("~.-~", ""):len() / 370
    SetDrawOrigin(paskaa)
    SetTextScale(0.35, 0.35)
    SetTextFont(6)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    DrawRect(0.0, 0.0125, TextLen, 0.03, 45, 45, 45, 150)
    ClearDrawOrigin()
end

CheckPed = function()
    for k, v in pairs(AR.DrugPlaces) do
        local Math = #(k - GetEntityCoords(Ped))

        if Math < 3.0 then
            return 0, k, v
        end
    end

    return 1100
end

CreateThread(function()
    while true do
        if Sleep == 0 and TakingDrugs then
            local Sleepcheck = CheckPed()

            if Sleepcheck == 0 then
                local WaitTime = math.random(3, 11) * 1000

                Wait(WaitTime)

                local SkillCheck = math.random(1, 100)
                local success = true

                if SkillCheck >= AR.SkillCheckTuuri then
                    success = lib.skillCheck(SkillSet[math.random(#SkillSet)], {'w', 'a', 's', 'd'})
                end

                if success and IsPedUsingScenario(Ped, "WORLD_HUMAN_GARDENER_PLANT") then
                    TriggerServerEvent("AR-Drugs:ObtainDrugs", Drug)
                end
            end

            TakingDrugs = false
            ClearPedTasksImmediately(Ped)
        end

        Wait(Sleep)
    end
end)

CreateThread(function()
    while true do
        Ped = PlayerPedId()
        Sleep, Coord, Drug = CheckPed()

        if Sleep == 0 then
            local Label = "Paina [E] lopettaaksesi huumeen kerääminen"

            if not TakingDrugs then
                Label = ("Paina [E] kerätäksesi %s"):format(AR.Translate[Drug])
            end

            DrawText3D(Coord, Label)

            if IsControlJustReleased(0, 38) then
                TakingDrugs = not TakingDrugs -- true to false, false to true

                if not TakingDrugs then
                    TaskStartScenarioInPlace(Ped, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
                else
                    ClearPedTasksImmediately(Ped)
                end
            end
        end

        Wait(Sleep)
    end
end)