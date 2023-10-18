
local Input = LUI.Element()

local DEFAULT_MAX_LENGTH = 50


function Input:init(args)
    args = args or {}
    self.text = elements.Text(self, {
        text = ""
    })
    self.onSubmit = args.onSubmit
    self.maxLength = args.maxLength or DEFAULT_MAX_LENGTH
end


function Input:onRender(x,y,w,h)
    local region = Region(x,y,w,h)
    mainStyle:rectangle(x,y,w,h)

    local textRegion = region:pad(10)
    if self:isFocused() then
        local _, cursorRegion = textRegion:splitHorizontal(0.9, 0.1)
        if math.floor(love.timer.getTime() * 2) % 2 == 0 then
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle("fill",cursorRegion:get())
        end
    end
    self.text:render(textRegion:get())
end


function Input:onMousePress()
    print("hi?")
    self:focus()
end



local SUBMIT = "return"
local BACKSPACE = "backspace"

function Input:onKeyPress(_, scancode, isrepeat)
    if not self:isFocused() then
        return
    end
    if scancode == SUBMIT then
        self:unfocus()
        return true
    end

    if scancode == BACKSPACE then
        -- delete character
        local txt = self.text:getText()
        local len = #txt
        local new = txt:sub(1,len-1)
        self.text:setText(new)
        return true
    end
end


function Input:onTextInput(text)
    if not self:isFocused() then
        return
    end
    local txt = self.text:getText() .. text
    self.text:setText(txt)
end


function Input:onUnfocus()
    if self.onSubmit then
        self:onSubmit(self.text:getText())
    end
end


return Input

