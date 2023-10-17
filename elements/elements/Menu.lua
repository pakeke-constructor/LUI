

local Menu = LUI.Element()


function Menu:init()
    self.button = elements.Button(self)

    self.scroll = elements.ScrollBar(self, {
        sensitivity = 5
    })
end


local SCROLL_WIDTH = 20

function Menu:onRender(x,y,w,h)
    love.graphics.rectangle("line",x,y,w,h)
    local region = Region(x,y,w,h)

    local main, scroll = region:splitHorizontal(w-SCROLL_WIDTH, SCROLL_WIDTH)

    local r = main:padRatio(0.25)
    local scr = -self.scroll:getScrollRatio() * h * 4
    self.button:render(r:offset(0,scr):get())

    self.scroll:render(scroll:get())
end


function Menu:onWheelMoved(_,dy)
    self.scroll:scroll(dy)
end


return Menu
