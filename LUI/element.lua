
local path = (...):gsub('%.[^%.]+$', '')

local util = require(path .. ".util")


local Element = {}


local function dispatchToChildren(self, funcName, ...)
    for _, child in ipairs(self.children) do
        child[funcName](child, ...)
    end
end



function Element:setup()
    -- called on initialization
    self.children = {}
    self.parent = nil
    self.view = {x=0,y=0,w=0,h=0} -- last seen view
    self.focused = false
    self.hovered = false
    self.clickedOnBy = {--[[
        [button] -> true/false
        whether this element is being clicked on by a mouse button
    ]]}

    self.focusedChild = nil -- only used by root elements
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
    self.clickedOnBy[button] = true

    for _, child in ipairs(self.children) do
        if child:contains(mx, my) then
            child:mousepressed(mx, my, button, istouch, presses)
        end
    end
end


function Element:mousereleased(mx, my, button, istouch, presses)
    -- should be called when mouse is released ANYWHERE in the scene
    if not self.clickedOnBy[button] then
        return -- This event doesn't concern this element
    end
    
    util.tryCall(self.onClickRelease, self, mx, my, button, istouch, presses)
    self.clickedOnBy[button] = true

    dispatchToChildren(self, "mousereleased", mx, my, button, istouch, presses)
end



local function updateHover(self, mx, my)
    if self.hovered then
        if not self:contains(mx, my) then
            util.tryCall(self.onEndHover, self, mx, my)
            self.hovered = false
        end
    else -- not being hovered:
        if self:contains(mx, my) then
            util.tryCall(self.onStartHover, self, mx, my)
            self.hovered = true
        end
    end
end



function Element:mousemoved(mx, my, dx, dy, istouch)
    util.tryCall(self.onMouseMoved, self, mx, my, dx, dy, istouch)

    updateHover(self, mx, my)
    dispatchToChildren(self, "mousemoved", mx, my, dx, dy, istouch)
end



function Element:keypressed(key, scancode, isrepeat)
    util.tryCall(self.onKeyPress, self, key, scancode, isrepeat)
    dispatchToChildren(self, "keypressed", key, scancode, isrepeat)
end


function Element:keyreleased(key, scancode)
    util.tryCall(self.onKeyRelease, self, key, scancode)
    dispatchToChildren(self, "keyreleased", key, scancode)
end


function Element:textinput(text)
    util.tryCall(self.onTextInput, self, text)
    dispatchToChildren(self, "textinput", text)
end



local function listDelete(arr, x)
    for i=1, #arr do
        if arr[i] == x then
            table.remove(arr, i)
            return
        end
    end
end

function Element:delete()
    local parent = self.parent
    if parent then
        listDelete(parent.children, self)
    end
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



local function setRootFocus(self, focus)
    local root = self:getRoot()
    local old = root.focusedChild
    if old then
        -- unfocus old element
        root.focusedChild = nil
        old:unfocus()
    end
    root.focusedChild = focus
end


function Element:focus()
    if self.focused then
        return -- idempotency
    end
    setRootFocus(self, self)
    self.focused = true
    util.tryCall(self.onFocus, self)
end


function Element:unfocus()
    if not self.focused then
        return -- idempotency
    end
    setRootFocus(self, nil)
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
