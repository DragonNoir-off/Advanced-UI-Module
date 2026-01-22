local module = {}

local Sound = {}

function module.load_assets()
    local SFX_liste = love.filesystem.getDirectoryItems("assets/Sounds/SFX")
    local Musique_liste = love.filesystem.getDirectoryItems("assets/Sounds/Musique")

    for _, file in ipairs(SFX_liste) do
        if file:match("%.png$") then
            -- file is an image
            local succ, err = pcall(function() -- prevent error if file isnt supported
                Sound[file] = love.audio.newSource("assets/Sounds/SFX/"..file, "static")
            end)
            if err then print("[[ ERROR | SoundsLoader.lua , module.load_assets() ]] -- "..err) end
        end
    end

    for _, file in ipairs(Musique_liste) do
        if file:match("%.png$") then
            -- file is an image
            local succ, err = pcall(function() -- prevent error if file isnt supported
                Sound[file] = love.audio.newSource("assets/Sounds/Musique/"..file, "stream")
            end)
            if err then print("[[ ERROR | SoundsLoader.lua , module.load_assets() ]] -- "..err) end
        end
    end
end

function module.Get(name)
    local sound = Sound[name]
    if sound then return sound:clone() else return nil end
end

return module