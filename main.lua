

_G.Region = require("examples.lib.region")
_G.LUI = require("LUI")

local elements = require("elements")

for k,v in pairs(elements) do
    print(k,v)
end


local b = elements.Button(false)


local function getScreenView()
    return 0,0, love.graphics.getDimensions()
end


function love.draw()
    b:render(getScreenView())
end


function love.mousepressed(x,y,button,istouch)
    b:mousepressed(x,y,button,istouch)
end

