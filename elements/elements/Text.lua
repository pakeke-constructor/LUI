

local Text = LUI.Element()


function Text:init(args)
    if type(args) == "string" then
        self.text = args
    else
        self.text = args.text
    end
end



local function getSize(text)
    local font = love.graphics.getFont()
    local width
    if type(text) == "table" then
        for i=2, #text, 2 do
            local txt = text[i]
            width = width + font:getWidth(txt)
        end
    else -- its a string
        return font:getWidth(text)
    end

    local height = font:getHeight()
    return width, height
end


function Text:onRender(x,y,w,h)
    local width, height = getSize(self.text)
    love.graphics.printf(self.text, x, y)
end


function Text:setText(text)
    self.text = text
end


return Menu


