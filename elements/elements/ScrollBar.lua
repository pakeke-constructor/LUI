

local ScrollBar = LUI.Element()


local ScrollThumb = LUI.Element()


local function clamp(x, min, max)
    return math.min(max, math.max(min, x))
end


function ScrollThumb:init(args)
    self.position = 0
    self.totalSize = 0
    for k,v in pairs(args) do
        self[k] = v
    end
end

local SCROLL_BUTTON = 1
function ScrollThumb:onMouseMoved(x, y, dx, dy, istouch)
    if self:isClickedOnBy(SCROLL_BUTTON) then
        self.position = clamp(self.position + dy, 0, self.totalSize)
    end
end

function ScrollThumb:onMousePress(x,y)
    print("button!")
end

function ScrollThumb:onRender(x,y,w,h)
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", x,y,w,h)
    love.graphics.setColor(self.outlineColor)
    love.graphics.rectangle("line", x,y,w,h)
end



local COL = {0.8,0.8,0.8}
local OUTLINE = {0.3,0.3,0.3}

function ScrollBar:init(args)
    self.thumb = ScrollThumb(self, {
        color = COL,
        outlineColor = OUTLINE
    })
end



local THUMB_RATIO = 5 -- thumb is 5 times smaller than scrollbar

function ScrollBar:onRender(x,y,w,h)
    local region = Region(x,y,w,h)
    love.graphics.rectangle("line",region:get())
    
    self.thumb.totalSize = h
    local thumbRegion = region
        :set(nil,nil,nil,h/THUMB_RATIO)
        :offset(0, self.thumb.position)
        :clampInside(region)
    self.thumb:render(thumbRegion:get())
end



return ScrollBar
