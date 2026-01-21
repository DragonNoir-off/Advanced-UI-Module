--[[ SERVICES ]]
local utf8 = require("utf8")

--[[ MODULES ]]
local UI = require("src.Modules.UI")
local Assets = require("src.Loader.AssetsLoader")
local task = require("src.Modules.Task")
local Tween = require("src.Modules.Tween")

--[[ DATA ]]
local PreLoadUserInterface = require("src.Data.PreLoadUserInterface")

--[[ CONSTANT ]]
local WINDOW_WIDTH = 960
local WINDOW_HEIGHT = 540
local SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getDesktopDimensions()

--[[ VARIABLES ]]

function love.load()
    -- LOAD ALL ASSETS
    Assets.load_assets()

    -- LOAD WINDOW CONFIGURATION
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {resizable=true, fullscreen=false, fullscreentype = "desktop"})
    love.window.setPosition((SCREEN_WIDTH - WINDOW_WIDTH)/2,(SCREEN_HEIGHT - WINDOW_HEIGHT)/2,1) -- place the windows in the center of the screen
    love.window.setTitle("Advanced UI Module")
    love.window.setIcon(love.image.newImageData("assets/Deepwoken_icon.png"))

    -- KEYBOARD CONFIGURATION
    love.keyboard.setKeyRepeat(true)

    -- UI CONFIGURATION
    PreLoadUserInterface.MainScene()

    image1 = UI.returnObjectFromPath("workspace/fire_slash")
    image2 = UI.returnObjectFromPath("workspace/fire_tornado")

    --UI.debug__showAll()
    local tween1 = Tween.create({
        start_data = 1,
        end_data = (#image1.attribut.quad),
        duration = 0.8,
        repeat_amount = -1,
        delay = 1,
        update_function = function(value)
            image1.attribut.sprite_quad_id = math.floor(value)
        end
    }):play()

    local tween2 = Tween.create({
        start_data = 1,
        end_data = (#image2.attribut.quad),
        duration = 0.2,
        delay = 0.2/(#image2.attribut.quad),
        repeat_amount = -1,
        update_function = function(value)
            image2.attribut.sprite_quad_id = math.floor(value)
        end
    }):play()
end

function love.update(dt)
    -- Module render update
    task.UpdateTask(dt)
    Tween.UpdateTween(dt)

    -- [[ TEST DIVERS ]]
    --image1:changeSize({image1.attribut.size.x + ( 100 * dt ),image1.attribut.size.y})
    --image1.attribut.rotation = image1.attribut.rotation + math.rad( dt * 60 )
    --image2.attribut.rotation = image2.attribut.rotation + math.rad( dt * 60 )
end

function love.keyreleased(key)
    if key == "escape" then love.event.quit() end
end

function love.draw()
    love.graphics.clear(0.2,0.2,0.2)
    UI.draw_ui()
end