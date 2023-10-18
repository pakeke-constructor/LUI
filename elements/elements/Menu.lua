

local Menu = LUI.Element()


function Menu:init()
    self.button = elements.Button(self)
    
    -- self.flex = elements.FlexBox({
    -- })

    self.text = elements.Text(self)
end


function Menu:onRender(x,y,w,h)
    local region = Region(x,y,w,h)
    local header, left, right

    header, region = region:splitVertical(0.2, 0.8)
    left, right = region:pad(16):splitHorizontal(0.5, 0.5)
    
    self.text:render(header:get())
end


return Menu
