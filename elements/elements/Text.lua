

local Text = LUI.Element()
--[[

Text is a text element that will scale itself to
automatically fit the given box.


]]


local function getTextSize(self)
    local font = love.graphics.getFont()
    local width
    if self.wrap then
        width = font:getWrap(self.text, self.wrap)
    else
        width = font:getWidth(self.text)
    end
    local height = font:getHeight()
    return width, height
end


function Text:init(args)
    if type(args) == "string" then
        self.text = args
    else
        self.text = args.text
        self.wrap = args.wrap -- whether we do text wrapping
    end
    
    self.scale = args.scale or 1
    self.align = args.align or "left"
    self:setPreferredSize(getTextSize(self))
end



function Text:onRender(x,y,w,h)
    local tw, th = getTextSize(self)
    self:setPreferredSize(tw, th)

    -- scale text to fit box
    local limit = self.wrap or tw
    local scale = math.min(w/limit, h/th) * self.scale
    local drawX, drawY = math.floor(x+w/2), math.floor(y+h/2)
    love.graphics.printf(self.text, drawX, drawY, limit, self.align, 0, scale, scale, tw/2, th/2)
end


function Text:setText(text)
    self.text = text
end


return Text

