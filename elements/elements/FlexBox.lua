

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



function FlexBox:init(args)
    assert(type(args) == "table", "bad args")
    assert(args.maxWidth and args.maxHeight, "?")

    for _, elem in ipairs(args) do
        local _,h = elem:getPreferredSize()
        if not h then
            error("element needs a preferred height!")
        end
        elem:setParent(self)
    end

    self.maxWidth = args.maxWidth
    self.maxHeight = args.maxHeight
    self.minWidth = args.minWidth or 0
    self.minHeight = args.minHeight or 0
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
        elemW = elemW or w
        prefH = prefH + elemH
        prefW = math.max(prefW, elemW or 0)
        elem:render(currY,x, elemW,elemH)
        currY = currY + elemW
    end

    if self:isRoot() then
        self:setView(x,y,prefW, prefH)
    else
        self:setPreferredSize(prefW, prefH)
    end
end



return FlexBox
