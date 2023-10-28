

local Menu = LUI.Element()


function Menu:init()
    self.button = elements.Button(self, {
        text = "Button!"
    })
    
    self.image = elements.Image(self, {
        image = love.graphics.newImage("examples/cat.jpg")
    })

    self.text = elements.Text(self, {
        text = "hi"
    })

    self.input = elements.Input(self)

    self.slider = elements.Slider(self, {
        min = 5,
        max = 30,
        startValue = 10,
        onValueChanged = function(slf, value)
            local par = slf:getParent()
            par.sliderText:setText(string.format("Slider: %.2f", value))
        end
    })
    self.sliderText = elements.Text(self, {
        text = "no value"
    })
end


function Menu:onRender(x,y,w,h)
    local region = Region(x,y,w,h)
    local header, left, right

    mainStyle:rectangle(region:get())

    header, region = region:pad(10):splitVertical(0.2, 0.8)
    left, right = region:pad(16):splitHorizontal(0.3, 0.5)
    
    mainStyle:rectangle(header:get())
    self.text:render(header:get())

    local topLeft, botLeft = left:splitVertical(0.2, 0.8)
    self.input:render(topLeft:padRatio(0.1):get())
    self.image:render(botLeft:padRatio(0.1):get())

    local top, bot = right:padRatio(0.1):splitVertical(0.2,0.8)
    self.slider:render(top:get())
    self.sliderText:render(bot:padRatio(0.15):get())
    --[[
    do
    local prefW, prefH = self.flex:getPreferredSize()
    local r = right
    local flexR = right:shrinkTo((prefW or r.w), (prefH or r.h))
    mainStyle:rectangle(flexR:get())
    self.flex:render(flexR:get())
    end
    ]]
end


function Menu:onResize(w,h)
    self:setPreferredSize(w,h)
end


return Menu
