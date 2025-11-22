Config = {}

-- General Staff Team Role (required to run commands)
Config.StaffTeamRoleID = "1234567890" -- Replace with actual STAFF_TEAM_ROLEID

-- Staff ranks in hierarchy (higher index = higher rank)
Config.StaffRoles = {
    "1111111111", -- Replace with actual STAFF_RANK_ROLEID_1
    "2222222222", -- Replace with actual STAFF_RANK_ROLEID_2
    "3333333333", -- Replace with actual STAFF_RANK_ROLEID_3
    "4444444444", -- Replace with actual STAFF_RANK_ROLEID_4
    "5555555555"  -- Replace with actual STAFF_RANK_ROLEID_5
}

-- Optional: Rank names for display
Config.RankNames = {
    ["1111111111"] = "Junior Staff", -- Replace with meaningful names for ranks
    ["2222222222"] = "Senior Staff",
    ["3333333333"] = "Head Staff",
    ["4444444444"] = "Admin",
    ["5555555555"] = "Owner"
}

-- Discord bot API (replace with valid endpoint returning roles by Discord ID)
Config.DiscordAPI = {
    Token = os.getenv("DISCORD_BOT_TOKEN"), -- Use environment variable for safety
    GuildID = "123456789012345678", -- Replace with actual GUILD_ID
    Endpoint = "https://yourbotserver.com/api/getroles" -- Replace with actual endpoint
}

-- UI settings (adjust positions/sizes to fit your needs)
Config.UI = {
    x = 0.12,      -- Horizontal position of the UI (0.0 to 1.0)
    y = 0.03,      -- Vertical position of the UI (0.0 to 1.0)
    width = 0.12,  -- Width of the UI component
    height = 0.045 -- Height of the UI component
}