


# API DRAFT 1:


# Elements:
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


function Elem:onDrag(x, y, dx, dy)
    -- called when the user drags the element with mouse-button 1
    print("element dragged")
end



function Elem:onMousemoved(x, y, dx, dy, istouch)
    if self:isFocused() and love.mouse.isDown(1) then
        -- We could use this for a scroll-bar!
    end
end


function Elem:onTextinput(text)
    if self:isFocused() then
        -- only input text if this elem is focused!
        self.text = self.text + text
    end
end
```

```lua
local element = Elem(parentElement or scene)

element:isHovered() -- true/false whether element is hovered by ptr

element:isFocused() -- true/false whether element is focused
-- Think like, a text input box ready to input text.


element:focus() -- focuses an element.
-- Only one element can be focused per scene.

element:unfocus() -- unfocuses element
```



---------------



# Scenes:
```lua
local scene = LUI.Scene()

-- callbacks to call:
local consumed = scene:mousepressed(x, y, button)
scene:mousereleased(x, y, button)

local consumed = scene:textinput(txt)

local consumed = scene:keypressed(key, scancode)
scene:keyreleased(key, scancode)
--[[
    `consumed` boolean checks if the input was consumed or not.
    Useful for locking mouse/keyboard inputs.
]]

scene:draw(x,y,w,h)


scene:_setFocus(elem) -- focuses an element in a scene
-- (This shouldn't need to be called)
```

