local onDuty = false
local dutyStart = 0
local lastSessionSeconds = 0
local staffRank = "[Staff Rank]"

-- Constants for configuration
local DEFAULT_UI = {
    x = 0.5,
    y = 0.5,
    width = 0.2,
    height = 0.1,
    font = 4,
    scale = { timer = 0.35, rank = 0.30 },
    colors = {
        timer = { 255, 255, 255, 255 },
        rank = { 200, 200, 255, 255 }
    }
}
local UI = Config and Config.UI or DEFAULT_UI

-- Helper function to format seconds into HH:MM:SS
local function FormatTime(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

-- Function to draw generic text
local function DrawTextUI(text, x, y, scale, color, center)
    SetTextFont(UI.font)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(table.unpack(color))
    SetTextCentre(center or false)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

-- Function to draw duty status UI
local function DrawDutyUI(timerText, rankText)
    DrawRect(UI.x, UI.y, UI.width, UI.height, 0, 0, 0, 150)
    DrawTextUI(timerText, UI.x - 0.06, UI.y - 0.015, UI.scale.timer, UI.colors.timer, false)
    DrawTextUI("Rank: " .. rankText, UI.x - 0.06, UI.y + 0.012, UI.scale.rank, UI.colors.rank, false)
end

-- Thread to draw UI while on duty
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(onDuty and 0 or 1000) -- Reduce CPU usage while off duty
        if onDuty then
            local elapsed = os.time() - dutyStart
            DrawDutyUI("STAFF DUTY: " .. FormatTime(elapsed), staffRank)
        end
    end
end)

-- Server-side validation callback
local function ValidateCommand(command)
    TriggerServerEvent("staff:validateRole", command) -- Ask the server for validation
end

-- Callback to notify about invalid role
RegisterNetEvent("staff:notifyInvalidRole")
AddEventHandler("staff:notifyInvalidRole", function()
    TriggerEvent("chat:addMessage", { args = {"^1ERROR:", "You do not have permission to use this command!"} })
end)

-- Events to toggle on/off duty
RegisterNetEvent("staff:goOnDuty")
AddEventHandler("staff:goOnDuty", function()
    if onDuty then
        TriggerEvent("chat:addMessage", { args = {"^1STAFF:", "You are already on duty!"} })
        return
    end
    onDuty = true
    dutyStart = os.time()
    TriggerEvent("chat:addMessage", { args = {"^2STAFF:", "You are now on duty!"} })
end)

RegisterNetEvent("staff:goOffDuty")
AddEventHandler("staff:goOffDuty", function()
    if not onDuty then
        TriggerEvent("chat:addMessage", { args = {"^1STAFF:", "You are not on duty!"} })
        return
    end
    onDuty = false
    TriggerEvent("chat:addMessage", { args = {"^2STAFF:", "You are now off duty!"} })
end)

-- Commands
RegisterCommand("ondutystaff", function() ValidateCommand("onDuty") end)
RegisterCommand("offdutystaff", function() ValidateCommand("offDuty") end)
RegisterCommand("stafftime", function()
    if onDuty then
        local elapsed = os.time() - dutyStart
        TriggerEvent("chat:addMessage", { args = {"^3STAFF TIME:", "Current duty time: " .. FormatTime(elapsed) .. " | Rank: " .. staffRank} })
    elseif lastSessionSeconds > 0 then
        TriggerEvent("chat:addMessage", { args = {"^3STAFF TIME:", "Last duty session: " .. FormatTime(lastSessionSeconds) .. " | Rank: " .. staffRank} })
    else
        TriggerEvent("chat:addMessage", { args = {"^3STAFF TIME:", "You are not on duty yet."} })
    end
end)