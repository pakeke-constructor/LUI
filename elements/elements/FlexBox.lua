

local FlexBox = LUI.Element()
--[[

FlexBox

FlexBoxes have maximum/minimum widths and heights.

FlexBoxes will ALWAYS try to fit the content as tight as possible.
That it, FlexBoxes will try to be the minimum size possible.

]]


local ARGS = {
    minWidth = true,
    minHeight = true,
    maxWidth = true,
    maxHeight = true
}


function FlexBox:init(args)
    assert(type(args) == "table", "bad args")
    for k,v in pairs(ARGS) do
        assert(args[k], "missing arg")
        self[k] = v
    end
end



return FlexBox
