
local Slider = LUI.Element()



local Thumb = LUI.Element()


local function clamp(x, min, max)
    return math.min(max, math.max(min, x))
end


local DEFAULT_SENSITIVITY = 5


local SCROLL_BUTTON = 1

function Thumb:onMouseMoved(x, y, dx, dy, istouch)
    if self:isClickedOnBy(SCROLL_BUTTON) then
        local parent = self:getParent()
        parent.position = clamp(parent.position + dy, 0, parent.totalSize)
    end
end

function Thumb:onRender(x,y,w,h)
    mainStyle:rectangle(x,y,w,h)
end







function Slider:init(args)
    self.onChangeValue = args.onChangeValue
    self.min = args.min
    self.max = args.max
    assert(self.min<=self.max,"wot wot")
    self.value = clamp(self.startValue or 0, self.min, self.max)

    self.thumb = Thumb(self)
end



function Slider:onRender(x,y,w,h)
    local region = Region(x,y,w,h)
    love.graphics.setColor(0.5,0.5,0.5)
    love.graphics.rectangle("line",region:get())
    
    self.totalSize = w
    local thumbRegion = region
        :set(nil,nil,w/THUMB_RATIO,nil)
        :offset(self.value, 0)
        :clampInside(region)
    self.thumb:render(thumbRegion:get())
end


return Slider
