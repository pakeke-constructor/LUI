
love.graphics.setDefaultFilter("nearest", "nearest")

local font = love.graphics.newImageFont("examples/font.png",
' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789><:$,.!@()|_?#;/\\[]       ')
love.graphics.setFont(font)


_G.Region = require("examples.lib.region")
_G.LUI = require("LUI")

local elements = require("elements")
_G.elements = elements




_G.mainStyle = require("examples.style")
mainStyle.LINE_WIDTH = 4
mainStyle.CORNER_RADIUS = 0


local function getScreenView()
    return 0,0, love.graphics.getDimensions()
end


local scene = LUI.Scene()

local e = elements.Menu(false)
e:setView(getScreenView())
scene:addElement(e)


function love.draw()
    scene:render()
end

function love.mousepressed(mx, my, button, istouch, presses)
    local consumed = scene:mousepressed(mx, my, button, istouch, presses)
end

function love.mousereleased(mx, my, button, istouch)
    scene:mousereleased(mx, my, button, istouch)
end

function love.mousemoved(mx, my, dx, dy, istouch)
    scene:mousemoved(mx, my, dx, dy, istouch)
end

function love.keypressed(key, sc, isrep)
    local consumed = scene:keypressed(key, sc, isrep)
end

function love.keyreleased(key, scancode)
    scene:keyreleased(key, scancode)
end

function love.textinput(text)
    local consumed = scene:textinput(text)
end

function love.wheelmoved(dx,dy)
    scene:wheelmoved(dx,dy)
end

function love.resize(x,y)
    scene:resize(x,y)
end


