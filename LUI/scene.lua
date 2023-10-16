

--[[

Element manager functionality.

Manages the current elements on the stack.

]]


local manager = {}


local beginFrameCalled = false

local stack = {}

function manager.push(element)
    -- pushes an element onto the stack.
    -- Elements should be automatically pushed after a call to :render
    assert(beginFrameCalled, "LUI.begin() needs to be called before rendering")
    table.insert(stack, element)
end


function manager.clearStack()
    stack = {}
end


function manager.getStack()
    return stack
end


return manager
