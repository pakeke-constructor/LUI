

--[[

Scene object

Scenes contain elements

]]



local path = (...):gsub('%.[^%.]+$', '')

local util = require(path .. ".util")

local Scene = util.Class()


function Scene:init()
    self.elements = {}
end


function Scene:addElement(element)
    table.insert(self.elements, element)
end



function Scene:removeElement(element)
    -- WARNING: This is O(n^2)
    util.listDelete(self.elements, element)
end


function Scene:focus(element)
    -- WARNING: This is O(n^2)
    util.listDelete(self.elements, element)
    table.insert(self.elements, element)
end


function Scene:render()
    for i=#self.elements, 1, -1 do
        local elem = self.elements[i]
        elem:render(elem:getView())
    end
end


local FOCUS_BUTTON = 1

function Scene:mousepressed(mx, my, button, istouch, presses)
    for i=#self.elements, 1, -1 do
        local elem = self.elements[i]
        if elem:contains(mx, my) then
            elem:mousepressed(mx, my, button, istouch, presses)
            if button == FOCUS_BUTTON then
                self:focus(elem)
            end
        end
    end
end

--[[
    TODO: Do the rest of these.
]]
function Element:mousereleased(mx, my, button, istouch, presses)
end

function Element:mousemoved(mx, my, dx, dy, istouch)
end

function Element:keypressed(key, scancode, isrepeat)
end

function Element:keyreleased(key, scancode)
end

function Element:textinput(text)
end




return Scene

