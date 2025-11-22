local onDuty = false
local dutyStart = 0
local lastSessionSeconds = 0
local staffRank = "[Staff Rank]"

local function FormatTime(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function DrawDutyUI(timerText, rankText)
    DrawRect(Config.UI.x, Config.UI.y, Config.UI.width, Config.UI.height, 0, 0, 0, 150)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(false)
    SetTextEntry("STRING")
    AddTextComponentString(timerText)
    DrawText(Config.UI.x - 0.06, Config.UI.y - 0.015)

    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.30, 0.30)
    SetTextColour(200, 200, 255, 255)
    SetTextCentre(false)
    SetTextEntry("STRING")
    AddTextComponentString("Rank: " .. rankText)
    DrawText(Config.UI.x - 0.06, Config.UI.y + 0.012)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if onDuty then
            local elapsed = os.time() - dutyStart
            DrawDutyUI("STAFF DUTY: " .. FormatTime(elapsed), staffRank)
        end
    end
end)

RegisterNetEvent("staff:setRank")
AddEventHandler("staff:setRank", function(rank)
    staffRank = rank
end)

RegisterCommand("ondutystaff", function()
    TriggerServerEvent("staff:onDuty")
    onDuty = true
    dutyStart = os.time()
end)

RegisterCommand("offdutystaff", function()
    if not onDuty then
        TriggerEvent("chat:addMessage", { args = {"^1STAFF:", "You are not on duty!"} })
        return
    end
    onDuty = false
    lastSessionSeconds = os.time() - dutyStart
    TriggerServerEvent("staff:offDuty", lastSessionSeconds)
end)

RegisterCommand("stafftime", function()
    if onDuty then
        local elapsed = os.time() - dutyStart
        TriggerEvent("chat:addMessage", { args = {"^3STAFF TIME:", "Current duty time: "..FormatTime(elapsed).." | Rank: "..staffRank} })
    else
        if lastSessionSeconds > 0 then
            TriggerEvent("chat:addMessage", { args = {"^3STAFF TIME:", "Last duty session: "..FormatTime(lastSessionSeconds).." | Rank: "..staffRank} })
        else
            TriggerEvent("chat:addMessage", { args = {"^3STAFF TIME:", "You are not on duty yet."} })
        end
    end
end)