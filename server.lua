local http = require("socket.http")
local json = require("json") -- Ensure JSON parser is available

-- Helper: Fetch player's Discord ID from identifiers
local function GetDiscordID(src)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if string.find(id, "discord:") then
            return string.sub(id, 9)
        end
    end
    return nil
end

-- Helper: Retrieve Discord roles via API
local function GetDiscordRoles(discordID)
    if not Config.DiscordAPI or not Config.DiscordAPI.Endpoint or not Config.DiscordAPI.GuildID then
        print("^1[ERROR] Missing Discord API configuration.")
        return {}
    end

    local url = string.format("%s?guild=%s&user=%s", Config.DiscordAPI.Endpoint, Config.DiscordAPI.GuildID, discordID)
    local body, code, _, status = http.request(url)
    if code ~= 200 or not body then
        print(("^1[ERROR] Failed to fetch Discord roles: HTTP %s (%s)"):format(code or "unknown", status or "unknown"))
        return {}
    end

    local success, roles = pcall(function() return json.decode(body) end)
    if not success then
        print("^1[ERROR] Invalid JSON response from Discord.")
        return {}
    end

    if type(roles) ~= "table" then
        print("^1[ERROR] Expected table of roles but got something else.")
        return {}
    end

    return roles
end

-- Helper: Check if the user has Staff Team's role
local function HasStaffTeamRole(roles)
    return Config.StaffTeamRoleID and table.contains(roles, Config.StaffTeamRoleID)
end

-- Helper: Get the user's highest staff rank based on predefined priorities
local function GetHighestRank(roles)
    for i = #Config.StaffRoles, 1, -1 do
        local roleID = Config.StaffRoles[i]
        if table.contains(roles, roleID) then
            return Config.RankNames[roleID] or "[Staff Rank]"
        end
    end
    return "[Staff Rank]"
end

-- Command: Go ON DUTY
RegisterNetEvent("staff:onDuty")
AddEventHandler("staff:onDuty", function()
    local src = source
    local discordID = GetDiscordID(src)
    if not discordID then
        DropPlayer(src, "Your Discord ID could not be validated. Ensure Discord is linked.")
        return
    end

    local roles = GetDiscordRoles(discordID)
    if not HasStaffTeamRole(roles) then
        DropPlayer(src, "You do not have permission to use staff commands.")
        return
    end

    local rank = GetHighestRank(roles)
    TriggerClientEvent("staff:setRank", src, rank)
    print(("[STAFF DUTY] Player %s (%s) went ON DUTY"):format(GetPlayerName(src), rank))
end)

-- Command: Go OFF DUTY
RegisterNetEvent("staff:offDuty")
AddEventHandler("staff:offDuty", function(totalSeconds)
    local src = source
    local discordID = GetDiscordID(src)
    if not discordID then return end

    local roles = GetDiscordRoles(discordID)
    if not HasStaffTeamRole(roles) then
        print("[STAFF DUTY] Invalid access attempted by a non-staff player.")
        return
    end

    local rank = GetHighestRank(roles)
    print(("[STAFF DUTY] Player %s (%s) went OFF DUTY after %s seconds"):format(GetPlayerName(src), rank, totalSeconds))
end)