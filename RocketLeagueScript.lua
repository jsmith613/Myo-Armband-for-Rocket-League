scriptId = 'com.example.rocketLeagueScript'
    scriptTitle = 'Rocket League Script'
    scriptDetailsUrl = ''

originRoll = 0
originPitch = 0
originYaw = 0

didCalibrate = false
myo.setLockingPolicy("none")

function onForegroundWindowChange(app, title)
    if (app == "RocketLeague.exe") then
        myo.debug("Rocket League Active ")
        myo.debug("didCalibrate: " .. tostring(didCalibrate))
        return true
    end
end

function activeAppName()
    return "Rocket League"
end


function onPeriodic()
    if (didCalibrate == true) then
        --If the pitch is within a certain threshold, drive forward
        if ((myo.getPitch() <= originPitch + 0.174533) and (myo.getPitch() >= originPitch - 0.174533)) then
            myo.keyboard("w","down")
            myo.debug("Forward Detected")
        end

        --Roll changes indicate turns
        if (myo.getRoll() > originRoll + .25) then
            myo.keyboard("d", "down")
            myo.debug("right Detected")
        end

        if (myo.getRoll() < originRoll - 0.25) then
            myo.keyboard("a","down")
            myo.debug("Left Detected")
        end

        if ((myo.getRoll() <= originRoll + .25) and (myo.getRoll() >= originRoll - 0.25)) then
            myo.keyboard("a","up")
            myo.keyboard("d","up")
        end

        --Pitch change of 10 degrees upward indicates coasting
        if (myo.getPitch() > originPitch + 0.174533) then
            myo.keyboard("w","up")
        end

        --Pitch change 50 degrees upward indicates braking
        if (myo.getPitch() > originPitch + 0.872665) then
            myo.keyboard("w","up")
            myo.keyboard("s", "press")
            myo.debug("Brake Detected")
        end
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
        onCalibrate()
    end

    if (didCalibrate == true) then
        if (edge == "on") then
            if (pose == "fist") then
                onFist()
            elseif (pose == "fingersSpread") then
                onFingersSpread()

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

function onFingersSpread()
end