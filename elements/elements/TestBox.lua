
local BigBox = LUI.Element()


local NUM_BUTTO = 10

function BigBox:init()
    self.height = 1000

    self.buttons = {}
    for _=1, NUM_BUTTO do
        table.insert(self.buttons, elements.Button(self))
    end
end


function BigBox:onRender(x,y,w,h)
    local r = Region(x,y,w,h):pad(20)
    love.graphics.setColor(1,0,0)
    love.graphics.setLineWidth(10)
    love.graphics.rectangle("line",r:get())
    
    do
    local buttonRegions = r:grid(1,NUM_BUTTO)
    for i, region in ipairs(buttonRegions) do
        love.graphics.setColor(1,1,1,1)
        self.buttons[i]:render(region:pad(10):get())
    end
    end
end



return BigBox
