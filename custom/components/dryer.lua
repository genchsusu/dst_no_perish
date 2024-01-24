local function FindLocalFunction(inst, name)
    local i, _value, _name = 0, nil, ""
    while _name ~= name do
        i = i + 1
        _name, _value = debug.getupvalue(inst, i)
    end
    return _value, i
end

AddComponentPostInit("dryer", function(inst)
    local doDryFunc, index = FindLocalFunction(inst.Resume, "DoDry")
    local _, index = FindLocalFunction(inst.Resume, "DoSpoil")
    
    if doDryFunc and index then
        -- print("Replace DoSpoil with DoDry function")
        debug.setupvalue(inst.Resume, index, doDryFunc)
    end

    local old_StopDrying = inst.StopDrying
    function inst:StopDrying(reason)
        old_StopDrying(reason)
        inst:Resume()
    end

    local old_LongUpdate = inst.LongUpdate
    function inst:LongUpdate(dt)
        old_LongUpdate(dt)
        inst:Resume()
    end

    function inst:GetTimeToSpoil()
        return self.ingredient == nil and (self.tasktotime ~= nil and 480000 or self.remainingtime) or 0
    end
end)