
local TestBox = LUI.Element()


local NUM_BUTTO = 10

function TestBox:init()
    self:setPreferredSize(nil, 1000)

    self.buttons = {}
    for _=1, NUM_BUTTO do
        table.insert(self.buttons, elements.Button(self, {}))
    end
end


function TestBox:onRender(x,y,w,h)
    local r = Region(x,y,w,h):pad(20)
    local height = 300 + 200 * math.sin(love.timer.getTime()/4)
    self:setPreferredSize(nil, height)
    love.graphics.setColor(1,0,0)
    love.graphics.setLineWidth(10)
    love.graphics.rectangle("line",r:get())
    
    do
    local ROWS = 2
    local buttonRegions = r:grid(ROWS,NUM_BUTTO/ROWS)
    for i, region in ipairs(buttonRegions) do
        self.buttons[i]:render(region:pad(10):get())
    end
    end
end



return TestBox
