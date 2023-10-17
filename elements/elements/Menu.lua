

local Menu = LUI.Element()


function Menu:init()
    self.button = elements.Button(self)

    self.scroll = elements.ScrollBar(self, {
        sensitivity = 10
    })
end


local SCROLL_WIDTH = 28

function Menu:onRender(x,y,w,h)
    love.graphics.rectangle("line",x,y,w,h)
    local region = Region(x,y,w,h)

    -- common idiom to create fixed-size splits:
    local main, scroll = region:splitHorizontal(w-SCROLL_WIDTH, SCROLL_WIDTH)

    local r = main:padRatio(0.25)

    local scrollSize = h * 4 -- for future, this should be an actual value
    local scr = -self.scroll:getScrollRatio() * scrollSize
    self.button:render(r:offset(0,scr):get())

    self.scroll:render(scroll:get())
end


function Menu:onWheelMoved(_,dy)
    self.scroll:scroll(dy)
end


return Menu
