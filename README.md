# FiveM Staff Duty Script

## Features
- `/ondutystaff`, `/offdutystaff`, `/stafftime` commands
- Auto Discord role detection for staff ranks
- Top-left UI showing timer + rank
- Staff-only command restriction

## Installation
1. Drop the `fivem-staffduty` folder into your `resources`.
2. Add `ensure fivem-staffduty` in your `server.cfg`.
3. Configure `config.lua`:
   - Add your **Staff Team Role ID**
   - Add your **staff rank IDs**
   - Add Discord bot token, guild ID, and endpoint

## Discord Bot
- You need a bot with an endpoint that returns roles for a user.
- The endpoint should return a JSON array of role IDs for the Discord member.
