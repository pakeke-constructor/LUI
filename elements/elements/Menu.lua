

local Menu = LUI.Element()


function Menu:init(a,b,c,d)
    self.button = elements.Button(self)
    self.scroll = elements.ScrollBar(self)
end


local SCROLL_WIDTH = 20

function Menu:onRender(x,y,w,h)
    love.graphics.rectangle("line",x,y,w,h)
    local region = Region(x,y,w,h)

    local main, scroll = region:splitHorizontal(w-SCROLL_WIDTH, SCROLL_WIDTH)

    local r = main:padRatio(0.25)
    self.button:render(r:get())

    self.scroll:render(scroll:get())
end



return Menu
