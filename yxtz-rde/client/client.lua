function IsPlayerInZone(playerCoords, zoneCoords, zoneRadius)
    local distance = #(playerCoords - zoneCoords)
    return distance < zoneRadius
end

function DisplayChatMessage(message, color)
    TriggerEvent('chat:addMessage', 
    {
        template = '<div style="font-weight:bold;margin-bottom: 2px;width:fit-content;padding: 1.5px 8px 5px 8px;margin-right: 0.40vw;background-color: rgba(0, 0, 0, 0.5);border-radius: 5px;border: rgba(255, 255, 255, 0.6) 2px solid;color: rgb(255, 0, 0)">{0}: <span style="color:white;font-weight:normal">{1}</span></div>',
        args = { "RDE", message } -- Replace "RDE" with whatever you want
    })
end


Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        for _, zone in ipairs(Config.Zones or {}) do
            if IsPlayerInZone(playerCoords, zone.coords, zone.radius) then
                local currentTime = GetGameTimer()
                if currentTime - zone.lastMessageTime > zone.cooldown then
                    DisplayChatMessage(zone.message, zone.color) 
                    zone.lastMessageTime = currentTime
                end
                break
            end
        end

        Citizen.Wait(1000)
    end
end)