local module = {}

-- Modules
local FormatModule = require("src.Module.format")

function module.new(red,green,blue,brightness)
    red = FormatModule.min_max(red,0,1)
    green = FormatModule.min_max(green,0,1)
    blue = FormatModule.min_max(blue,0,1)
    brightness = FormatModule.min_max(brightness,0,1)

    return {red,green,blue,brightness}
end

function module.fromRGB(red,green,blue,brightness)
    return module.new(red/255,green/255,blue/255,(brightness or 255)/255)
end

local ColorTable = {}

function module.fromPalette(color_name)
    return (ColorTable[color_name] or module.new(1,1,1,1))
end

return module