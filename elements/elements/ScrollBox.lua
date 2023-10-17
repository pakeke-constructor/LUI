
local ScrollBox = LUI.Element()


local SCROLL_WIDTH = 20



function ScrollBox:init(args)
    assert(args.content, "No content given!")
    args.content:setParent(self)

    self.scrollWidth = args.scrollWidth or SCROLL_WIDTH

    self.content = args.content

    self.scroll = elements.ScrollBar(self, {
        sensitivity = args.sensitivity
    })
end



function ScrollBox:onRender(x,y,w,h)
    love.graphics.rectangle("line",x,y,w,h)
    local region = Region(x,y,w,h)

    -- common idiom to create fixed-size splits:
    local content, scroll = region:splitHorizontal(w-self.scrollWidth, self.scrollWidth)

    do
    local contentHeight = self.content.height
    assert(contentHeight, "Content element needs a .height field")
    local dy = -self.scroll:getScrollRatio() * (contentHeight - h)
    local X,Y,W,_H = content:offset(0,dy):get()
    self.content:render(X,Y,W,contentHeight)
    end

    self.scroll:render(scroll:get())
end


function ScrollBox:onWheelMoved(_,dy)
    self.scroll:scroll(dy)
end


return ScrollBox

