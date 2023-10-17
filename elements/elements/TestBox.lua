
local BigBox = LUI.Element()


function BigBox:init()
    self.height = 1000
end


function BigBox:onRender(x,y,w,h)
    local r = Region(x,y,w,h):pad(20)
    love.graphics.setColor(1,0,0)
    love.graphics.setLineWidth(10)
    love.graphics.rectangle("line",r:get())

    for yy=50, self.height, 100 do
        love.graphics.print("im scrolling!",30,yy+y,0,2,2)
    end
end



return BigBox
