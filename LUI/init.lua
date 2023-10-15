
local PATH = (...):gsub('%.init$', '')

local LUI = {}


LUI.Region = require(PATH .. ".region")
LUI.Element = require(PATH .. ".element")
LUI.Scene = require(PATH .. ".scene")


return LUI

