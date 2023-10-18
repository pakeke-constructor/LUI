

local Button = LUI.Element()


local DEFAULT_PADDING = 12


function Button:init(args)
    self.onClick = args.onClick
    self.text = args.text
    self.padding = args.padding or DEFAULT_PADDING
end


local function ensureTextElement(self)
    if not self.textElement then
        self.textElement = elements.Text(self, {
            text = self.text
        })
    end

    if self.textElement.text ~= self.text then
        -- we need to update!
        self.textElement.text = self.text
    end
end



function Button:onRender(x,y,w,h)
    local r = Region(x,y,w,h)
    mainStyle:rectangle(r:get())

    local prefW, prefH
    if self.text then
        ensureTextElement(self)
        local pW, pH = self.textElement:getPreferredSize()
        self.textElement:render(x,y,w,h)
        local p = self.padding
        prefW, prefH = (pW or r.w) + p*2, (pH or r.h) + p*2
    end

    if self.image then
        
    end

    if prefW then
        self:setPreferredSize(prefW,prefH)
    end
end



function Button:onMousePress(x,y)
    if self.onClick then
        self:onClick(x,y)
    end
end




return Button

