

local Button = LUI.Element()



function Button:init(a,b,c)
    print("inited:", a,b,c)
    self.count = 0
end


function Button:render(x,y,w,h)
    love.graphics.rectangle("line",x,y,w,h)
    love.graphics.print(tostring(self.count), x + 10, y + 10)
end


function Button:onClick(x,y)
    self.count = self.count + 1
end




return Button

