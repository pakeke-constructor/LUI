

local Text = LUI.Element()


local function getSize(text)
    local font = love.graphics.getFont()
    local width
    if type(text) == "table" then
        for i=2, #text, 2 do
            local txt = text[i]
            width = width + font:getWidth(txt)
        end
    else -- its a string
        width = font:getWidth(text)
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
    
    print("Hello?", self.text)
    self:setPreferredSize(getSize(self.text))
end



function Text:onRender(x,y,w,h)
    local width, height
    if self.wrap then
        local font = love.graphics.getFont()
        width = font:getWrap(self.text)
        height = font:getHeight()
    else
        width, height = getSize(self.text)
    end

    local limit = self.wrap and width or w
    love.graphics.printf(self.text, x, y, limit, "center")
end


function Text:setText(text)
    self.text = text
end


return Text

