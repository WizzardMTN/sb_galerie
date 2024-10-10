local isDisplayingArtwork = false

local isDisplayingArtwork = false
local promptGroup = GetRandomIntInRange(0, 0xffffff)
local viewPrompt

Citizen.CreateThread(function()
    viewPrompt = PromptRegisterBegin()
    PromptSetControlAction(viewPrompt, Config.DisplayKey)
    PromptSetText(viewPrompt, CreateVarString(10, "LITERAL_STRING", "Kunst betrachten"))
    PromptSetEnabled(viewPrompt, 1)
    PromptSetVisible(viewPrompt, 1)
    PromptSetStandardMode(viewPrompt, 1)
    PromptSetGroup(viewPrompt, promptGroup)
    PromptRegisterEnd(viewPrompt)

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, artwork in ipairs(Config.ArtworkPoints) do
            local distance = #(playerCoords - artwork.coords)
            
            if distance < 2.0 then
                PromptSetActiveGroupThisFrame(promptGroup, CreateVarString(10, "LITERAL_STRING", artwork.name))
                
                if PromptHasStandardModeCompleted(viewPrompt) then
                    if not isDisplayingArtwork then
                        DisplayArtwork(artwork.artwork)
                    else
                        HideArtwork()
                    end
                end
            end
        end
    end
end)

function DisplayArtwork(artworkUrl)
    SendNUIMessage({
        type = "showArtwork",
        url = artworkUrl
    })
    isDisplayingArtwork = true
    SetNuiFocus(true, true)
end

function HideArtwork()
    SendNUIMessage({
        type = "hideArtwork"
    })
    isDisplayingArtwork = false
    SetNuiFocus(false, false)
end

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end

RegisterNUICallback('closeArtwork', function(data, cb)
    HideArtwork()
    cb('ok')
end)