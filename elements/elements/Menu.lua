

local Menu = LUI.Element()


function Menu:init()
    self.button = elements.Button(self)
end


function Menu:onRender(x,y,w,h)
    love.graphics.rectangle("line",x,y,w,h)

    local r = Region(x,y,w,h):padRatio(0.25)
    self.button:render(r:get())
end



return Menu
