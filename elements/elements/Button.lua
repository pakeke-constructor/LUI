

local Button = LUI.Element()



function Button:init()
    self.count = 0
end


function Button:onRender(x,y,w,h)
    -- love.graphics.rectangle("line",x,y,w,h)
    -- love.graphics.print(tostring(self.count), x + 10, y + 10)
    mainStyle:rectangle(x, y, w, h)
    mainStyle:printf(tostring(self.count), x, y, w, "center")
end


function Button:onMousePress(x,y)
    self.count = self.count + 1
end




return Button

