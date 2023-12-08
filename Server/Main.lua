ESX = nil TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("AR-Drugs:ObtainDrugs")
AddEventHandler("AR-Drugs:ObtainDrugs", function(Drug)
    local Source = source
    if not SAR.Drugs[Drug] then
        return DropPlayer(Source, GetCurrentResourceName() .. " | Broidi yritti ottaa tavaraa joka ei oo listassa " .. Drug)
    end

    local xPlayer = ESX.GetPlayerFromId(Source)
    xPlayer.addInventoryItem(SAR.Drugs[Drug], 1)
end)