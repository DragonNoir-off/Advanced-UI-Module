--[[ SERVICES ]]
local utf8 = require("utf8")

--[[ MODULES ]]
local UI = require("src.Modules.UI")
local Assets = require("src.Loader.AssetsLoader")
local task = require("src.Modules.Task")

--[[ DATA ]]
local PreLoadUserInterface = require("src.UI_DATA.PreLoadUserInterface")

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

    image1 = UI.returnObjectFromPath("workspace/image3")
end

function love.update(dt)
    task.UpdateTask(dt)
    image1:changeSize({image1.attribut.size.x + ( 100 * dt ),image1.attribut.size.y})
    image1.attribut.rotation = image1.attribut.rotation + math.rad( dt * 20 )
end

function love.keypressed(key, _)
    
end

function love.draw()
    love.graphics.clear(0.2,0.2,0.2)
    UI.draw_ui()
end