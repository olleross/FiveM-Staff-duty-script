local onDuty = false
local duties = {}

-- Function to start server duty
function startServerDuty()
    print("[SERVER DUTY] Duty initialization started.")    -- Raw example
end

-- Function endServer commands complete major transition phases

local http = require("socket.http")
local json = require("json") -- ensure JSON parser is available

local function GetDiscordID(src)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if string.find(id, "discord:") then
            return string.sub(id, 9)
        end
    end
    return nil
end

local function GetDiscordRoles(discordID)
    local url = string.format("%s?guild=%s&user=%s", Config.DiscordAPI.Endpoint, Config.DiscordAPI.GuildID, discordID)
    local body, code = http.request(url)
    if code ~= 200 or not body then return {} end
    local success, roles = pcall(function() return json.decode(body) end)
    if success and type(roles) == "table" then return roles end
    return {}
end

local function HasStaffTeamRole(roles)
    for _, r in ipairs(roles) do
        if r == Config.StaffTeamRoleID then return true end
    end
    return false
end

local function GetHighestRank(roles)
    for i = #Config.StaffRoles, 1, -1 do
        local roleID = Config.StaffRoles[i]
        for _, r in ipairs(roles) do
            if r == roleID then
                return Config.RankNames[roleID] or "[Staff Rank]"
            end
        end
    end
    return "[Staff Rank]"
end

RegisterNetEvent("staff:onDuty")
AddEventHandler("staff:onDuty", function()
    local src = source
    local discordID = GetDiscordID(src)
    if not discordID then return end
    local roles = GetDiscordRoles(discordID)
    if not HasStaffTeamRole(roles) then
        DropPlayer(src, "You do not have permission to use staff commands.")
        return
    end
    local rank = GetHighestRank(roles)
    TriggerClientEvent("staff:setRank", src, rank)
    print(("[STAFF DUTY] Player %s (%s) went ON DUTY"):format(src, rank))
end)

RegisterNetEvent("staff:offDuty")
AddEventHandler("staff:offDuty", function(totalSeconds)
    local src = source
    local discordID = GetDiscordID(src)
    if not discordID then return end
    local roles = GetDiscordRoles(discordID)
    if not HasStaffTeamRole(roles) then return end
    local rank = GetHighestRank(roles)
    print(("[STAFF DUTY] Player %s (%s) went OFF DUTY after %s"):format(src, rank, totalSeconds))
end)