

local ScrollBar = LUI.Element()


local ScrollThumb = LUI.Element()


function ScrollBar:init(a,b,c,d)
    self.button = elements.Button(self)
end


function ScrollBar:dragged()


function ScrollBar:onRender(x,y,w,h)
    love.graphics.rectangle("line",x,y,w,h)

    local r = Region(x,y,w,h):padRatio(0.25)
    self.button:render(r:get())
end



return ScrollBar
