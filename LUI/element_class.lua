
local path = (...):gsub('%.[^%.]+$', '')

local util = require(path .. ".util")


local Element = {}


function Element:shouldUseStencil()
    -- to be overridden
    return true
end


function Element:render(x,y,w,h)
    local useStencil = self:shouldUseStencil()
    if useStencil then
        local function stencil()
            love.graphics.rectangle("fill",x,y,w,h)
        end
        love.graphics.stencil(stencil, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
    end

    util.tryCall(self.onRender, self, x,y,w,h)

    if useStencil then
        love.graphics.setStencilTest()
    end

    self.view.x = x
    self.view.y = y
    self.view.w = w
    self.view.h = h
end




local MAX_DEPTH = 10000

function Element:getRoot()
    -- gets the root ancestor of this element
    local elem = self
    for _=1,MAX_DEPTH do
        if elem.parent then
            elem = elem.parent
        else
            return elem -- its the root!
        end
    end
    error("max depth reached in element heirarchy (child is a parent of itself?)")
end


function Element:isInside(x,y)
    -- returns true if (x,y) is inside element bounds
    local view = self.view
    local X,Y,W,H = view.x,view.y,view.w,view.h
    return  X <= x and x <= (X+W)
        and Y <= y and y <= (Y+H) 
end


local function setParent(childElem, parentElem)
    table.insert(parentElem.children, childElem)
    childElem.parent = parentElem
end


local function initElement(elementClass, parent, ...)
    local element = setmetatable({}, elementClass)
    element.children = {}
    element.view = {x=0,y=0,w=0,h=0} -- last seen view
    setParent(element, parent)
    if element.init then
        element:init(parent, ...)
    end
    return element
end


local ElementClass_mt = {
    __call = initElement,
    __index = Element
}


local function newElementClass()
    --[[
        two layers of __index here;
        one to `ElementClass`, and then to `Element`.
    ]]
    local elementClass = {}
    elementClass.__index = elementClass
    setmetatable(elementClass, ElementClass_mt)

    return elementClass
end


return newElementClass

