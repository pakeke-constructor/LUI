


# API DRAFT 1:


# Elements:
```lua
local Elem = LUI.ElementClass()

function Elem:init(args)
    self.button = Button(self, {})
    self.input = TextInput(self)
    -- we can put any elements we want here
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
    print("element clicked")
end

function Elem:onClickChild(child, mx, my, button)
    print("A child of this element has been clicked!")
end
```

```lua
local element = Elem(parentElement or scene)

element:isHovered() -- true/false whether element is hovered by ptr

element:isFocused() -- true/false whether element is focused
-- Think like, a text input box ready to input text.

element:focus() -- focuses an element. All elements in the root
element:unfocus() -- unfocuses element
```



# Immediates:
Immediates are just like regular elements, but they have no state,
and they don't need to be stored anywhere.<br/>
(Useful for popups or toasts.)
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

