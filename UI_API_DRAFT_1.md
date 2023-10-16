


# API DRAFT 1:


----------


# Elements:

Functions we can override:
```lua
local Elem = LUI.ElementClass()

function Elem:init(args)
    self.button = Button(self, {})
    self.input = TextInput(self)
    -- we can put any elements we want here
    self.text = ""
end

function Elem:onRender(region)
    love.graphics.rectangle("line", region:get())

    local left, right = region:splitHorizontal(0.4, 0.6)
    
    self.button:render(left:pad(20))
    self.input:render(right:pad(20))
end


function Elem:onStartHover(mx, my)
    print("element started being hovered")
end

function Elem:onEndHover(mx, my)
    print("element stopped being hovered")
end

function Elem:onClick(mx, my, button)
    self:focus()
    print("element clicked")
end

function Elem:onClickRelease(mx, my, button)
    print("element released!")
end


function Elem:onKeyPress(key,scancode) end
function Elem:onKeyRelease(key,scancode) end


function Elem:onMouseMoved(x, y, dx, dy, istouch)
    if self:isFocused() and love.mouse.isDown(1) then
        -- We could use this for a scroll-bar!
    end
end


function Elem:onTextInput(text)
    if self:isFocused() then
        -- only input text if this elem is focused!
        self.text = self.text + text
    end
end
```

```lua
local element = Elem(parentElement)

element:isHovered() -- true/false whether element is hovered by ptr

element:isFocused() -- true/false whether element is focused
-- Think like, a text input box ready to input text.


element:focus() -- focuses an element.
-- Only one element can be focused per heirarchy.
-- (Therefore, this call will un-focus anything else in the heirarchy.)

element:unfocus() -- unfocuses element
```

---------------

```lua
local element = Elem("ROOT")
--[[
    Creates a root element.

    It's a common idiom to have the root element represent
    the current scene.
]]
```


