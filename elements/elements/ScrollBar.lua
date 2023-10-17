

local ScrollBar = LUI.Element()


local ScrollThumb = LUI.Element()


local function clamp(x, min, max)
    return math.min(max, math.max(min, x))
end


local EMPTY = {}

local DEFAULT_SENSITIVITY = 5


function ScrollThumb:init(args)
    args = args or EMPTY
end

local SCROLL_BUTTON = 1
function ScrollThumb:onMouseMoved(x, y, dx, dy, istouch)
    if self:isClickedOnBy(SCROLL_BUTTON) then
        local parent = self:getParent()
        parent.position = clamp(parent.position + dy, 0, parent.totalSize)
    end
end

function ScrollThumb:onRender(x,y,w,h)
    mainStyle:rectangle(x,y,w,h)
end



function ScrollBar:init(args)
    self.position = 0
    self.totalSize = 0
    self.sensitivity = args.sensitivity or DEFAULT_SENSITIVITY
    self.thumb = ScrollThumb(self, args)
end


function ScrollBar:scroll(dy)
    local t = self.thumb
    local delta = dy * t.sensitivity
    clamp(t.position + delta, 0, self.totalSize)
end

function ScrollBar:onWheelMoved(_, dy)
    self:scroll(self,dy)
end


function ScrollBar:getScroll()
    return self.position
end

function ScrollBar:getScrollRatio()
    return self.position / self.totalSize
end


local THUMB_RATIO = 5 -- thumb is 5 times smaller than scrollbar

function ScrollBar:onRender(x,y,w,h)
    local region = Region(x,y,w,h)
    love.graphics.rectangle("line",region:get())
    
    self.totalSize = h
    local thumbRegion = region
        :set(nil,nil,nil,h/THUMB_RATIO)
        :offset(0, self.position)
        :clampInside(region)
    self.thumb:render(thumbRegion:get())
end



return ScrollBar
