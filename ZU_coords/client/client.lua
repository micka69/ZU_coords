-- coords.lua

-- Fonction pour dessiner du texte avec un fond à l'écran
function DrawTextWithBackground(x, y, text, scale, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
    
    local textWidth = GetTextScaleWidth(scale, string.len(text)) / 2
    DrawRect(x + textWidth, y + 0.0125, textWidth * 2 + 0.005, 0.03, 0, 0, 0, 0)
end

-- Fonction pour calculer la largeur du texte en fonction de l'échelle
function GetTextScaleWidth(scale, textLength)
    return scale * 0.55 * textLength
end

-- Boucle principale du script
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Boucle rapide pour mise à jour en temps réel
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)
        
        local x = coords.x
        local y = coords.y
        local z = coords.z

        -- Affichage des coordonnées en haut à gauche de l'écran avec des couleurs et un fond
        DrawTextWithBackground(0.015, 0.015, string.format("X : %.2f", x), 0.6, 255, 100, 100, 255)
        DrawTextWithBackground(0.015, 0.055, string.format("Y : %.2f", y), 0.6, 100, 255, 100, 255)
        DrawTextWithBackground(0.015, 0.095, string.format("Z : %.2f", z), 0.6, 100, 100, 255, 255)
        DrawTextWithBackground(0.015, 0.135, string.format("H : %.2f", heading), 0.6, 255, 255, 100, 255)
    end
end)

-- Fonction pour copier les coordonnées dans le presse-papiers (pour les clients Windows)
RegisterCommand("copycoords", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    local x = coords.x
    local y = coords.y
    local z = coords.z

    -- Format des coordonnées
    local coordVector3 = string.format("vector3(%.2f, %.2f, %.2f)", x, y, z)
    local coordVector4 = string.format("vector4(%.2f, %.2f, %.2f, %.2f)", x, y, z, heading)
    local coordXYZH = string.format("x = %.2f, y = %.2f, z = %.2f, h = %.2f", x, y, z, heading)
    
    -- Copier les coordonnées dans le presse-papiers
    SendNUIMessage({
        action = "copy",
        text = coordVector3 .. "\n" .. coordVector4 .. "\n" .. coordXYZH
    })
    
    -- Notification pour indiquer que les coordonnées ont été copiées
    SetNotificationTextEntry("STRING")
    AddTextComponentString("Coordonnées copiées dans le presse-papiers.")
    DrawNotification(false, true)
end, false)


  