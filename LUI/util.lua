

local util = {}


function util.tryCall(func, ...)
    -- calls `func` if it isnt nil
    if func then
        return func(...)
    end
end


function util.Class()
    local Class = {}
    local mt = {__index = Class}

    local function new(_class, ...)
        local obj = {}
        setmetatable(obj, mt)
        if Class.init then
            Class.init(obj, ...)
        end
        return obj
    end

    return setmetatable(Class, {
        __call = new
    })
end


return util

