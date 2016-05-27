scriptId = 'com.example.rocketLeagueScript'
    scriptTitle = 'Rocket League Script'
    scriptDetailsUrl = ''

originRoll = 0
originPitch = 0
originYaw = 0

didCalibrate = false
myo.setLockingPolicy("none")

FORWARD_THRESHOLD = 0.174533
tempForwardThreshold = FORWARD_THRESHOLD
TURN_THRESHOLD = .25
BRAKE_THRESHOLD = 0.872665
JUMP_THRESHOLD = 1.3

--jumpTimer allows the user time after jumping to get into coast position
jumpTimer = 0

function onForegroundWindowChange(app, title)
    if (app == "RocketLeague.exe") then
        return true
    end
end

function activeAppName()
    return "Rocket League"
end


function onPeriodic()
    if (didCalibrate == true) then

        --If the pitch is within a certain threshold, drive forward
        if ((myo.getPitch() <= originPitch + tempForwardThreshold) and (myo.getPitch() >= originPitch - tempForwardThreshold)) then
            if ((myo.getYaw() < originYaw + .15) or (myo.getYaw() > originYaw - .15)) then
                myo.keyboard("w","down")
            end

        end

        --Roll changes indicate turns
        if (myo.getRoll() > originRoll + TURN_THRESHOLD) then
            myo.keyboard("d", "down")

        end

        if (myo.getRoll() < originRoll - TURN_THRESHOLD) then
            myo.keyboard("a","down")

        end

        if ((myo.getRoll() <= originRoll + TURN_THRESHOLD) and (myo.getRoll() >= originRoll - TURN_THRESHOLD)) then
            myo.keyboard("a","up")
            myo.keyboard("d","up")
        end

        --Pitch change of 10 degrees upward indicates coasting
        if (myo.getPitch() > originPitch + FORWARD_THRESHOLD) then
            myo.keyboard("w","up")
        end

        --Yaw Change of .25 radians indicates coasting
        if ((myo.getYaw() > originYaw + .15) or (myo.getYaw() < originYaw - .15)) then
            myo.keyboard("w","up")
        end

        --Pitch change 50 degrees upward indicates braking
        if (myo.getPitch() > originPitch + BRAKE_THRESHOLD) then
            myo.keyboard("w","up")
            myo.keyboard("s", "press")
        end

        x,y,z = myo.getGyro()
        if (jumpTimer == 0) then
            if ((y > 100) or (z > 100)) then
                myo.mouse("right","click")
                jumpTimer = 30
            end
        end

        if (jumpTimer > 0) then
            jumpTimer = jumpTimer - 1
        end

        -- x,y,z = myo.getAccelWorld()
        -- if (z >= JUMP_THRESHOLD) then
        --     myo.mouse("right", "click")
        --     jumpTimer = 100
        -- end

        -- if (jumpTimer > 0) then
        --     jumpTimer = jumpTimer - 1
        --     myo.debug("jumpTimer: " ..jumpTimer)
        -- end
    end
end

function onActiveChange(isActive)
end

function onCalibrate()
    originRoll = myo.getRoll()
    originPitch = myo.getPitch()
    originYaw = myo.getYaw()
    didCalibrate = true
    myo.debug("originRoll: " ..originRoll)
    myo.debug("originPitch: " ..originPitch)
    myo.debug("originYaw: " ..originYaw)
end

function onPoseEdge(pose, edge)
    if (pose == "doubleTap") then
        if (jumpTimer == 0) then
            onCalibrate()
            myo.debug("Calibrated")
            myo.vibrate("short")
        end
    end

    if (didCalibrate == true) then
        if (edge == "on") then
            if (pose == "fist") then
                onFist()
            end
        end
        if (edge == "off") then
            if (pose == "fist") then
                offFist()
            end
        end
    end
end

function onFist()
    myo.mouse("left", "down")
end

function offFist()
    myo.mouse("left", "up")
end