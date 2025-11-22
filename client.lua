-- Enhanced script for standalone staff duty functionality

-- Configuration
local staffDutyActive = false
local staffDutyDuration = 3600 -- 1 hour in seconds

-- Function to start staff duty
function startStaffDuty()
    if not staffDutyActive then
        staffDutyActive = true
        print("Staff duty has been activated.")
        -- Additional logic for starting staff duty...
        Citizen.SetTimeout(staffDutyDuration * 1000, endStaffDuty)
    else
        print("Staff duty is already active.")
    end
end

-- Function to end staff duty
function endStaffDuty()
    if staffDutyActive then
        staffDutyActive = false
        print("Staff duty has ended.")
    else
        print("Staff duty is not active.")
    end
end

-- Command to start staff duty
RegisterCommand('startStaffDuty', startStaffDuty)

-- Command to end staff duty
RegisterCommand('endStaffDuty', endStaffDuty)