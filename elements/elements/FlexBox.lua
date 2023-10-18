

local FlexBox = LUI.Element()
--[[

FlexBox

A FlexBox is a box that takes an arbitrary number of elements,
and renders them top-to-bottom.
All elements inside of FlexBoxes (should) have a preferred width/height.

FlexBoxes have maximum/minimum widths and heights.

FlexBoxes will ALWAYS try to fit the content as tight as possible.
That is, FlexBoxes will try to be the minimum size possible.

]]


local DEFAULT_PADDING = 12

function FlexBox:init(args)
    for _, elem in ipairs(args) do
        elem:setParent(self)
    end

    self.padding = args.padding or DEFAULT_PADDING
end


function FlexBox:onRender(x,y,w,h)
    local children = self:getChildren()
    local defaultHeight = h/(#children)

    -- the preferred w/h of the FlexBox
    local prefH = 0
    local prefW = 0
    local currY = y

    for _, elem in ipairs(children) do
        local elemW,elemH = elem:getPreferredSize()
        elemH = elemH or defaultHeight
        elemW = elemW or (w - self.padding*2)
        prefH = prefH + elemH
        prefW = math.max(prefW, elemW or 0)
        local ex, ey = x + self.padding, currY + self.padding
        elem:render(ex,ey, elemW,elemH)
        currY = currY + elemH
    end

    prefW, prefH = prefW + self.padding*2, prefH + self.padding*2

    if self:isRoot() then
        self:setView(x,y,prefW, prefH)
    else
        self:setPreferredSize(prefW, prefH)
    end
end



return FlexBox
