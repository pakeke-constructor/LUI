

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

    self.scrollBox = elements.ScrollBox(self, {
        content = elements.TestBox(self)
    })
end


function Menu:onRender(x,y,w,h)
    local region = Region(x,y,w,h)
    local header, left, right

    mainStyle:rectangle(region:get())

    header, region = region:padPixels(10):splitVertical(0.2, 0.8)
    left, right = region:padPixels(16):splitHorizontal(0.3, 0.5)
    
    mainStyle:rectangle(header:get())
    self.text:render(header:get())

    local topLeft, botLeft = left:splitVertical(0.2, 0.8)
    self.input:render(topLeft:pad(0.1):get())
    self.image:render(botLeft:pad(0.1):get())

    local top, bot = right:pad(0.03):splitVertical(0.3,0.8)
    local sliderText, slider = top:splitVertical(0.5,0.5)
    self.slider:render(slider:get())
    self.sliderText:render(sliderText:pad(0.1):get())

    self.scrollBox:render(bot:pad(0.08):get())
end


function Menu:onResize(w,h)
    self:setPreferredSize(w,h)
end


return Menu
