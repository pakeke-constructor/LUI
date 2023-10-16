
local path = (...):gsub('%.[^%.]+$', '')

local util = require(path .. ".util")


local Element = {}


function Element:setup()
    -- called on initialization
    self.children = {}
    self.view = {x=0,y=0,w=0,h=0} -- last seen view
    self.focused = false
    self.hovered = false
    self.clickedOnBy = {--[[
        [button] -> true/false
        whether this element is being clicked on by a mouse button
    ]]}
end


function Element:shouldUseStencil()
    -- to be overridden
    return true
end


local function setView(self, x,y,w,h)
    -- save the last view
    local view = self.view
    view.x = x
    view.y = y
    view.w = w
    view.h = h
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
    
    setView(self, x,y,w,h)
end



function Element:mousepressed(mx, my, button, istouch, presses)
    -- should be called when mouse clicks on this element
    util.tryCall(self.onClick, self, mx, my, button, istouch, presses)
    self.beingClickedOn[button] = true

    for _, child in ipairs(self.children) do
        if child:contains(mx, my) then
            child:mousepressed(mx, my, button, istouch, presses)
        end
    end
end


function Element:mousereleased(mx, my, button, istouch, presses)
    -- should be called when mouse is released ANYWHERE in the scene
    if not self.beingClickedOn[button] then
        return -- This event doesn't concern this element
    end
    
    util.tryCall(self.onClickRelease, self, mx, my, button, istouch, presses)
    self.beingClickedOn[button] = true

    for _, child in ipairs(self.children) do
        child:mousereleased(mx, my, button, istouch, presses)
    end
end



local function updateHover(self, mx, my)
    if self.hovered then
        if not self:contains(mx, my) then
            util.tryCall(self.onEndHover, self, mx, my)
            self.hovered = false
        end
    else -- not being hovered:
        if self:contains(mx, my) then
            util.tryCall(self.onEndHover, self, mx, my)
            self.hovered = true
        end
    end
end


local DRAG_BUTTON = 1

function Element:mousemoved(mx, my, dx, dy, istouch)
    if self.beingClickedOn[DRAG_BUTTON] then
        -- this element is being dragged!
        util.tryCall(self.onDrag, self, mx, my, dx, dy, istouch)
    end

    updateHover(self, mx, my)

    for _, child in ipairs(self.children) do
        child:mousemoved(mx, my, dx, dy, istouch)
    end
end




local MAX_DEPTH = 10000

function Element:getRootScene()
    -- gets the rootScene ancestor of this element
    local elem = self
    for _=1,MAX_DEPTH do
        if elem.parent then
            elem = elem.parent
        else
            return elem -- its the rootScene!
        end
    end
    error("max depth reached in element heirarchy (child is a parent of itself?)")
end


function Element:focus()
    local rootScene = self:getRootScene()
    rootScene:_setFocus(self)
    self.focused = true
    util.tryCall(self.onFocus, self)
end


function Element:unfocus()
    local rootScene = self:getRootScene()
    rootScene:_setFocus(self)
    self.focused = false
    util.tryCall(self.onUnfocus, self)
end


function Element:isFocused()
    return self.focused
end



function Element:contains(x,y)
    -- returns true if (x,y) is inside element bounds
    local view = self.view
    local X,Y,W,H = view.x,view.y,view.w,view.h
    return  X <= x and x <= (X+W)
        and Y <= y and y <= (Y+H) 
end



return Element
