local module = {}

local Assets = {}

function module.load_assets()
    local assets_list = love.filesystem.getDirectoryItems("assets/Images")

    for _, file in ipairs(assets_list) do
        if file:match("%.png$") then
            -- file is an image
            local succ, err = pcall(function() -- prevent error if file isnt supported
                Assets[file] = love.graphics.newImage("assets/Images/"..file)
            end)
            if err then print("[[ ERROR | AssetsLoader.lua , module.load_assets() ]] -- "..err) end
        end
    end
end

function module.Get(name)
    return Assets[name]
end

return module