--[[ SERVICES ]]
local utf8 = require("utf8")

--[[ MODULES ]]
local UI = require("src.Modules.UI")
local Assets = require("src.Loader.AssetsLoader")
local Task = require("src.Modules.Task")

--[[ DATA ]]
local PreLoadUserInterface = require("src.UI_DATA.PreLoadUserInterface")

--[[ CONSTANT ]]
local WINDOW_WIDTH = 960
local WINDOW_HEIGHT = 540
local SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getDesktopDimensions()

--[[ VARIABLES ]]
local timestamp = 0

function love.load()
    -- LOAD WINDOW CONFIGURATION
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT, {resizable=true, fullscreen=false, fullscreentype = "desktop"})
    love.window.setPosition((SCREEN_WIDTH - WINDOW_WIDTH)/2,(SCREEN_HEIGHT - WINDOW_HEIGHT)/2,1) -- place the windows in the center of the screen
    love.window.setTitle("Advanced UI Module")

    -- KEYBOARD CONFIGURATION
    love.keyboard.setKeyRepeat(true)

    -- LOAD ALL ASSETS
    Assets.load_assets()

    -- UI CONFIGURATION
    PreLoadUserInterface.MainScene()
end

function love.update(dt)
    timestamp = timestamp + dt
end

function love.draw()
    love.graphics.clear(0.2,0.2,0.2)
    UI.draw_ui()
end