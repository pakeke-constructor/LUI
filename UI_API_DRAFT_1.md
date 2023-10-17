

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
    if self:isClickedOnBy(1) then
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
local element = Elem(false) -- Creates a root element.
```




# Scene objects:

--------------

```lua


local scene = Scene()

-- Adding elements:
scene:addElement(myElement)
scene:addElement(elem2)

-- Removing elements:
scene:removeElement(elem2)


function love.draw()
    scene:render()
end

function love.keypressed(key, sc, isrep)
    local consumed = scene:keypressed(key, sc, isrep)
end
```

Important ideas:
- We can only add an element to a scene if its a Root element!

- Only poll keyboard/textinput to the "top" element in the scene stack.
    - DONE

- Elements auto-deactivated if they weren't rendered the prev frame.
    Deactivated = unable to receive events or anything.


--------

Things to think about:
- How do we know when to "consume" keyboard input?
    - SOLN: Return `true` from :keypressed to consume.

