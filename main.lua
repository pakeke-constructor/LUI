
_G.Region = require("examples.lib.region")
_G.LUI = require("LUI")

local elements = require("elements")
_G.elements = elements


local m = elements.Menu(false, "hi", {}, 69)


local function getScreenView()
    return 0,0, love.graphics.getDimensions()
end


function love.draw()
    m:render(getScreenView())
end


function love.mousepressed(x,y,button,istouch)
    m:mousepressed(x,y,button,istouch)
end

function love.mousemoved(x,y,dx,dy,istch)
    m:mousemoved(x,y,dx,dy,istch)
end

function love.mousereleased(mx, my, button, istouch, presses)
    m:mousereleased(mx, my, button, istouch, presses)
end

