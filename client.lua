local onDuty = false
local dutyStart = 0
local lastSessionSeconds = 0
local staffRank = "[Staff Rank]"

-- Helper function to format seconds into HH:MM:SS
local function FormatTime(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

-- Function to draw duty status UI
local function DrawDutyUI(timerText, rankText)
    DrawRect(Config.UI.x, Config.UI.y, Config.UI.width, Config.UI.height, 0, 0, 0, 150)

    -- Timer text
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(false)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(timerText)
    EndTextCommandDisplayText(Config.UI.x - 0.06, Config.UI.y - 0.015)

    -- Rank text
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.30, 0.30)
    SetTextColour(200, 200, 255, 255)
    SetTextCentre(false)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString("Rank: " .. rankText)
    EndTextCommandDisplayText(Config.UI.x - 0.06, Config.UI.y + 0.012)
end

-- Main thread to handle duty display
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if onDuty then
            local elapsed = os.time() - dutyStart
            DrawDutyUI("STAFF DUTY: " .. FormatTime(elapsed), staffRank)
        end
    end
end)

-- Event to set staff rank
RegisterNetEvent("staff:setRank")
AddEventHandler("staff:setRank", function(rank)
    if type(rank) == "string" then
        staffRank = rank
    else
        print("^1ERROR: Invalid rank received.")
    end
end)

-- Command to go on staff duty
RegisterCommand("ondutystaff", function()
    if onDuty then
        TriggerEvent("chat:addMessage", { args = {"^1STAFF:", "You are already on duty!"} })
        return
    end
    TriggerServerEvent("staff:onDuty")
    onDuty = true
    dutyStart = os.time()
    TriggerEvent("chat:addMessage", { args = {"^2STAFF:", "You are now on duty!"} })
end)

-- Command to go off staff duty
RegisterCommand("offdutystaff", function()
    if not onDuty then
        TriggerEvent("chat:addMessage", { args = {"^1STAFF:", "You are not on duty!"} })
        return
    end
    onDuty = false
    lastSessionSeconds = os.time() - dutyStart
    TriggerServerEvent("staff:offDuty", lastSessionSeconds)
    TriggerEvent("chat:addMessage", { args = {"^2STAFF:", "You are now off duty!"} })
end)

-- Command to display staff time
RegisterCommand("stafftime", function()
    if onDuty then
        local elapsed = os.time() - dutyStart
        TriggerEvent("chat:addMessage", { args = {"^3STAFF TIME:", "Current duty time: " .. FormatTime(elapsed) .. " | Rank: " .. staffRank} })
    else
        if lastSessionSeconds > 0 then
            TriggerEvent("chat:addMessage", { args = {"^3STAFF TIME:", "Last duty session: " .. FormatTime(lastSessionSeconds) .. " | Rank: " .. staffRank} })
        else
            TriggerEvent("chat:addMessage", { args = {"^3STAFF TIME:", "You are not on duty yet."} })
        end
    end
end)