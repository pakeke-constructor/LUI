
local path = (...):gsub('%.[^%.]+$', '')

local util = require(path .. ".util")


local Element = {}


local function dispatchToChildren(self, funcName, ...)
    for _, child in ipairs(self._children) do
        if child:isActive() then
            child[funcName](child, ...)
        end
    end
end

local function forceDispatchToChildren(self, funcName, ...)
    for _, child in ipairs(self._children) do
        child[funcName](child, ...)
    end
end


function Element:setParent(parent)
    self._parent = parent
end

function Element:getParent()
    return self._parent
end



function Element:setup()
    -- called on initialization
    self._childElementHash = {--[[
        [childElem] -> true
        for checking if we have an elem or not
    ]]}
    self._children = {}

    self._parent = false
    -- Parent of this element.
    -- Could be a Scene, or a parent Element

    self._view = {x=0,y=0,w=0,h=0} -- last seen view
    self._focused = false
    self._active = false
    self._hovered = false
    self._clickedOnBy = {--[[
        [button] -> true/false
        whether this element is being clicked on by a mouse button
    ]]}

    self._isRoot = false
    -- if this is set to true, then we will accept this element as a "root".
    -- For example, a `Scene` is regarded as a root element.
end


function Element:isRoot()
    -- element with no parent = root element
    return not self._parent
end


function Element:makeRoot()
    --[[
        Denotes this element as a "Root" element.
        This basically tells us that we can draw this element in a detatched fashion.

        (For example, a "Scene" is a good example of a "Root" element)
    ]]
    self._isRoot = true
end



local function setParent(childElem, parent)
    if parent and childElem:getParent() then
        error("Element was already contained inside something else!")
    end
    assert(childElem ~= parent, "???")
    childElem:setParent(childElem, parent)
end




local function assertElementValid(elem)
   if type(elem) ~= "table" or (not elem.render) then
        error("not valid LUI element: " .. tostring(elem))
    end
end


function Element:addChild(childElem)
    if self:hasChild(childElem) then
        return --already has.
    end
    assertElementValid(childElem)
    table.insert(self._children, childElem)
    self._childElementHash[childElem] = true
    setParent(childElem, self)
    return childElem
end


function Element:removeChild(childElem)
    if not self:hasChild(childElem) then
        return
    end
    util.listDelete(self._children, childElem)
    self._childElementHash[childElem] = nil
    setParent(childElem, nil)
end


function Element:hasChild(childElem)
    return self._childElementHash[childElem]
end




local function setView(self, x,y,w,h)
    -- set the view
    local view = self._view
    view.x = x
    view.y = y
    view.w = w
    view.h = h
end


function Element:setView(x,y,w,h)
    --[[
        the view can only be set explicitly by root elements
    ]]
    assert(self:isRoot(), "Views can only be set explicitly by root elements")
    setView(self, x,y,w,h)
end


function Element:getView()
    local view = self._view
    return view.x,view.y,view.w,view.h
end


local function deactivateheirarchy(self)
    self._active = false
    for _, childElem in ipairs(self._children) do
        deactivateheirarchy(childElem)
    end
end

local function activate(self)
    self._active = true
end


function Element:startStencil(x,y,w,h)
    local function stencil()
        love.graphics.rectangle("fill",x,y,w,h)
    end
    love.graphics.stencil(stencil, "replace", 2)
    love.graphics.setStencilTest("greater", 1)
end


function Element:endStencil()
    love.graphics.setStencilTest()
end


function Element:render(x,y,w,h)
    if not self:getParent() then
        error("Attempt to render uncontained element!", 2)
    end
    deactivateheirarchy(self)
    activate(self)

    util.tryCall(self.onRender, self, x,y,w,h)

    setView(self, x,y,w,h)
end



function Element:mousepressed(mx, my, button, istouch, presses)
    -- should be called when mouse clicks on this element
    if not self:contains(mx,my) then
        return false
    end
    util.tryCall(self.onMousePress, self, mx, my, button, istouch, presses)
    self._clickedOnBy[button] = true

    for _, child in ipairs(self._children) do
        if child:contains(mx, my) and child:isActive() then
            child:mousepressed(mx, my, button, istouch, presses)
        end
    end
    return true -- consumed!
end


function Element:mousereleased(mx, my, button, istouch, presses)
    -- should be called when mouse is released ANYWHERE in the scene
    if not self._clickedOnBy[button] then
        return -- This event doesn't concern this element
    end
    
    util.tryCall(self.onMouseRelease, self, mx, my, button, istouch, presses)
    self._clickedOnBy[button] = false

    forceDispatchToChildren(self, "mousereleased", mx, my, button, istouch, presses)
end



local function updateHover(self, mx, my)
    if self._hovered then
        if not self:contains(mx, my) then
            util.tryCall(self.onEndHover, self, mx, my)
            self._hovered = false
        end
    else -- not being hovered:
        if self:contains(mx, my) then
            util.tryCall(self.onStartHover, self, mx, my)
            self._hovered = true
        end
    end
end



function Element:mousemoved(mx, my, dx, dy, istouch)
    util.tryCall(self.onMouseMoved, self, mx, my, dx, dy, istouch)

    updateHover(self, mx, my)
    dispatchToChildren(self, "mousemoved", mx, my, dx, dy, istouch)
end


function Element:wheelmoved(dx,dy)
    if self:isHovered() then
        util.tryCall(self.onWheelMoved, self, dx, dy)
        dispatchToChildren(self, "wheelmoved", dx, dy)
    end
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


function Element:resize(x,y)
    util.tryCall(self.onResize, self, x, y)
    dispatchToChildren(self, "resize", x, y)
end




function Element:getParent()
    return self._parent
end


function Element:getChildren()
    return self._children
end


local function maxDepthError()
    error("max depth reached in element heirarchy (Element is a child of itself?)")
end


local MAX_DEPTH = 10000

function Element:getRoot()
    -- gets the root ancestor of this element
    local elem = self
    for _=1,MAX_DEPTH do
        local parent = elem:getParent()
        if parent then
            elem = parent
        else
            return elem -- its the root!
        end
    end
    maxDepthError()
end



function Element:setFocusedChild(elem)
    
end



function Element:focus()
    if self:isFocused() then
        return
    end

    util.tryCall(self.onFocus, self)
    local root = self:getRoot()
    if scene then
        scene:_focus(self)
    end
end



function Element:unfocus()
    if not self:isFocused() then
        return
    end

    util.tryCall(self.onUnfocus, self)
    local scene = self:getRoot()
    if scene then
        scene:_unfocus()
    end
end


function Element:getPreferredSize()
    return self._prefWidth, self._prefHeight
end


function Element:setPreferredSize(w,h)
    self._prefWidth = w
    self._prefHeight = h
    if self:isRoot() then
        -- Well damn! Why ask the boss, when you are the boss?
        local x,y = self:getView()
        self:setView(x,y, w,h)
    end
end



function Element:isFocused()
    local root = self:getScene()
    return root:getFocusedChild() == self
end


function Element:isHovered()
    return self._hovered
end


function Element:isActive()
    --[[
        returns whether an element is active or not.

        If an element was :render()ed the previous frame,
        then its active.
    ]]
    return self._active
end



function Element:isClickedOnBy(button)
    -- returns true iff the element is clicked on by
    return self._clickedOnBy[button]
end



function Element:contains(x,y)
    -- returns true if (x,y) is inside element bounds
    local X,Y,W,H = self:getView()
    return  X <= x and x <= (X+W)
        and Y <= y and y <= (Y+H) 
end



return Element
