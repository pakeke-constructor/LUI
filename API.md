

# API DRAFT 1:


----------


# Elements:

Functions we can override:
```lua
local Elem = LUI.Element()

function Elem:init(args)
    self.button = Button(self, {})
    self.input = TextInput(self)
    -- we can put any elements we want here
    self.text = ""
end

function Elem:onRender(region)
    love.graphics.rectangle("line", region:get())

    local left, right = region:splitHorizontal(0.4, 0.6)
    
    self.button:render(left:padPixels(20))
    self.input:render(right:padPixels(20))
end


function Elem:onStartHover(mx, my)
    print("element started being hovered")
end

function Elem:onEndHover(mx, my)
    print("element stopped being hovered")
end

function Elem:onMousePress(mx, my, button)
    self:focus()
    print("element clicked")
end

function Elem:onMouseRelease(mx, my, button)
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

element:isActive() -- true if element is active, false otherwise.
-- (If an element was rendered last frame, it is active, else, inactive)

element:focus() -- focuses an element.
-- Only one element can be focused per heirarchy.
-- (Therefore, this call will un-focus anything else in the heirarchy.)

element:unfocus() -- unfocuses element
```

---------------

```lua
local element = Elem(false) -- Creates a root element. (false=root)
-- root elements can be added to Scenes.

local child = OtherElem(element)
-- creates an element that is a child of `element`.
-- (99% of the time, this will be done inside of the `Elem` constructor)

```




# Scene objects / putting it all together:

--------------

```lua


local scene = Scene()


function love.load()
    -- Adding elements:
    scene:addElement(myElement)
    scene:addElement(elem2)

    -- Removing elements:
    scene:removeElement(elem2)
end


function love.draw()
    scene:render()
end

function love.mousepressed(mx, my, button, istouch, presses)
    local consumed = scene:mousepressed(mx, my, button, istouch, presses)
end

function love.mousereleased(mx, my, button, istouch)
    scene:mousereleased(mx, my, button, istouch)
end

function love.mousemoved(mx, my, dx, dy, istouch)
    scene:mousemoved(mx, my, button, istouch, presses)
end

function love.keypressed(key, sc, isrep)
    local consumed = scene:keypressed(key, sc, isrep)
end

function love.keyreleased(key, scancode)
    scene:keyreleased(key, scancode)
end

function love.textinput(text)
    local consumed = scene:textinput(text)
end

function love.wheelmoved(dx,dy)
    scene:wheelmoved(dx,dy)
end


```

## Gotchas:
- We can only add an element to a scene if its a Root element!
    - ie. if its `parent == false`


## Things to think about:
- How do we know when to "consume" keyboard input?
    - SOLN: Return `true` from :keypressed to consume.

