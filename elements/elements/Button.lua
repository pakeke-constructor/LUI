

local Button = LUI.Element()


local DEFAULT_PADDING = 12


function Button:init(args)
    self.onClick = args.onClick
    self.text = args.text
    self.padding = args.padding or DEFAULT_PADDING
end


local function ensureTextElement(self)
    if not self.textElement then
        self.textElement = elements.Text({
            text = self.text
        })
        self:addChild(self.textElement)
    end

    if self.textElement.text ~= self.text then
        -- we need to update!
        self.textElement.text = self.text
    end
end



function Button:onRender(x,y,w,h)
    local r = Region(x,y,w,h)
    mainStyle:rectangle(r:get())

    if self.text then
        ensureTextElement(self)
        self.textElement:render(x,y,w,h)
        local p = self.padding
    end

    if self.image then
        
    end
end



function Button:onMousePress(x,y)
    if self.onClick then
        self:onClick(x,y)
    end
end




return Button

