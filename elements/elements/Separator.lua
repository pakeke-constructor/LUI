

local Separator = LUI.Element()


local SEPARATOR_SIZE = 8

function Separator:init()
    self:setPreferredSize(nil, SEPARATOR_SIZE)
end

function Separator:onRender(x,y,w,h)
    -- draws a horizontal line separator
    local yy = y+h/2
    mainStyle:line(
        x, yy,
        x+w, yy
    )
end


return Separator
