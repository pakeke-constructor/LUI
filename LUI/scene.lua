

--[[

Scene object

A Scene is just a regular LUI Element,
that contains other LUI Elements.

Scenes

]]

--[===[

local path = (...):gsub('%.[^%.]+$', '')

local util = require(path .. ".util")
local Element = require(path .. ".ElementClass")


local Scene = Element()


function Scene:init()
    self._focusedElement = false

    self:makeRoot()
end



-- Private method!
function Scene:_unfocus()
    self._focusedElement = false 
end


local function setTop(self, elem)
    -- sets `elem` to be rendered last.
    local children = self.getChildren()
    if not util.find(children, elem) then
        return
    end
    util.listDelete(children, elem)
    table.insert(children, elem)
end


-- Private method!
function Scene:_focus(elem)
    -- Focuses an element.
    -- Think like, a text box, ready to be typed in.

    -- only 1 element can be focused at a time:
    local prevElement = self:getFocused()
    if prevElement then
        prevElement:unfocus()
    end

    -- bring root element to top:
    local rootElem = elem:getRoot()
    setTop(self, rootElem)
    
    self._focusedElement = elem
end



function Scene:render(x,y,w,h)
    for i=#self.elements, 1, -1 do
        local elem = self.elements[i]
        elem:render(elem:getView())
    end
end


function Scene:getFocused()
    return self._focusedElement
end

local function tryCallFocused(self, method, ...)
    local focused = self:getFocused(self)
    if focused then
        focused[method](focused, ...)
    end
end

local function callForAll(self, method, ...)
    for i=#self.elements, 1, -1 do
        local elem = self.elements[i]
        elem[method](elem, ...)
    end
end




function Scene:mousepressed(mx, my, button, istouch, presses)
    for i=#self.elements, 1, -1 do
        local elem = self.elements[i]
        if elem:contains(mx, my) then
            elem:mousepressed(mx, my, button, istouch, presses)
        end
    end
end



function Scene:mousereleased(mx, my, button, istouch)
    callForAll(self, "mousereleased", mx, my, button, istouch)
end

function Scene:mousemoved(mx, my, dx, dy, istouch)
    callForAll(self, "mousemoved", mx, my, dx, dy, istouch)
end

function Scene:keypressed(key, scancode, isrepeat)
    tryCallFocused(self, "keypressed", key, scancode, isrepeat)
end

function Scene:keyreleased(key, scancode)
    callForAll(self, "keyreleased", key, scancode)
end

function Scene:textinput(text)
    tryCallFocused(self, "textinput", text)
end

function Scene:wheelmoved(dx,dy)
    callForAll(self, "wheelmoved", dx, dy)
end

function Scene:resize(x,y)
    callForAll(self, "resize", x,y)
end


return Scene

]===]
