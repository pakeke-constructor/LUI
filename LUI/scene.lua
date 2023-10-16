

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



return Scene

