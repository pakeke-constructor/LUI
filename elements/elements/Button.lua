

local Button = LUI.Element()



function Button:init(args)
    self.onClick = args.onClick
    self.text = args.text
end


function Button:onRender(x,y,w,h)
    mainStyle:rectangle(x, y, w, h)
    if self.text then
        mainStyle:printf(tostring(self.text), x, y, w, "center")
    end
end


function Button:onMousePress(x,y)
    if self.onClick then
        self:onClick(x,y)
    end
end




return Button

