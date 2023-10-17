

local ScrollBar = LUI.Element()


local ScrollThumb = LUI.Element()


local function clamp(x, min, max)
    return math.min(max, math.max(min, x))
end


function ScrollThumb:init(sensitivity)
    self.position = 0
    self.sensitivity = sensitivity -- mouse wheel sensitivity
    self.totalSize = 0
end

local SCROLL_BUTTON = 1
function ScrollThumb:onMouseMoved(x, y, dx, dy, istouch)
    if self:isClickedOnBy(SCROLL_BUTTON) then
        self.position = clamp(self.position + dy, 0, self.totalSize)
    end
end

function ScrollThumb:render(x,y,w,h)
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", x,y,w,h)
    love.graphics.setColor(self.outlineColor)
    love.graphics.rectangle("line", x,y,w,h)
end


function ScrollBar:init()
    self.thumb = ScrollThumb(self)
end



local THUMB_RATIO = 5 -- thumb is 5 times smaller than scrollbar

function ScrollBar:onRender(x,y,w,h)
    local region = Region(x,y,w,h)
    love.graphics.rectangle("line",region:get())
    
    self.thumb.totalSize = h
    local thumbRegion = region
        :set(nil,nil,nil,h/THUMB_RATIO)
        :offset(0, self.thumb.position)
    self.thumb:render(thumbRegion:get())
end



return ScrollBar
