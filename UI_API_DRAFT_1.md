


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

function Elem:render(region)
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

function Elem:onMousemoved(x, y, dx, dy, istouch)
    if self:isFocused() and love.mouse.isDown(1) then
        -- We could use this for a scroll-bar!
    end
end

function Elem:onClickChild(child, mx, my, button)
    print("A child of this element has been clicked!")
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
-- All elements in the scene will be unfocused, except this one.

element:unfocus() -- unfocuses element
```



---------------


# Immediates:
Immediates are regular elements that have no state.<br/>
Great for elements that pop in and out of existance all the time.
(EG, popups, toasts, info-boxes)

Since Immediate elements have no state,
we don't need to handle their creation/deletion;
we can just render them directly.
```lua
local Popup = LUI.ImmediateElement()

function Popup:render(region, args)
    love.graphics.print(args.text, region.x, region.y)
end
```
Rendering:
```lua
function MyElem:render(region)
    -- ImmediateElements cannot be instantiated, so
    -- we must render them statically:
    Popup:render(region:pad(20), {
        text = "hello"
    })
end
```

TODO ^^^ Is there any point in this?
How is this different from just calling a function?
Isn't this just an overcomplicated way to call a function...?
Do some thinking.

If we think of ANY justification to keep Child elements,
then we should keep them.
Else, get rid of them.


---------------




# Scenes:
```lua
local scene = LUI.Scene()

-- callbacks to call:
scene:mousepressed(x, y, button)
scene:mousereleased(x, y, button)

scene:textinput(txt)

scene:keypressed(key, scancode)
scene:keyreleased(key, scancode)

```

