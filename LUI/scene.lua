

local path = (...):gsub('%.[^%.]+$', '')
local util = require(path .. ".util")


local Scene = util.Class()

--[[
    TODO:
    use spatial partitioning for scenes
]]


function Scene:init()
    self.children = {}
    self.focused = nil
end


function Scene:render(x,y,w,h)
    x = x or 0
    y = y or 0
    local screenW, screenH = love.graphics.getDimensions()
    w, h = w or screenW, h or screenH
    for _, child in ipairs(self.children) do
        child:render(x,y,w,h)
    end
end


function Scene:_setFocus(element)
    element = element or self.focused
    if self.focused == element then
        local focused = self.focused
        self.focused = nil
        focused:unfocus()
    end
    self.focused = element
end


return Scene
