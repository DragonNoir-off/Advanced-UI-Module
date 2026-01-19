local module = {}

-- Modules
local FormatModule = require("src.Modules.Format")

function module.new4(red,green,blue,brightness)
    red = FormatModule.min_max(red,0,1)
    green = FormatModule.min_max(green,0,1)
    blue = FormatModule.min_max(blue,0,1)
    brightness = FormatModule.min_max(brightness,0,1)

    return {red,green,blue,brightness}
end

function module.fromRGB(red,green,blue,brightness)
    return module.new4(red/255,green/255,blue/255,(brightness or 255)/255)
end

function module.new3(red,green,blue)
    return module.new4(red,green,blue,255)
end

local ColorTable = {
    white = module.new4(1,1,1,1),
    blue = module.new4(0,0,1,1),
    green = module.new4(0,1,0,1),
    red = module.new4(1,0,0,1)
}

function module.fromPalette(color_name)
    return (ColorTable[color_name] or module.new4(1,1,1,1))
end

return module