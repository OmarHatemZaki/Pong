--[[
    Omar Hatem
    GD50 2020
    Pong Remake
]]

--Push is a library that allows
push = require 'push'

--Actual window size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--Virtual window size to imitate the low res feel of retro games

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--Runs when the game first starts up, only once; used to initialize the game.
function love.load()

  love.graphics.setDefaultFilter('nearest', 'nearest')
  --This initlizes our virtual resolution, which will be rendered inside our
  --actual window no matter its dimensions; replaces our typical love.window.setmode()
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end


function love.keypressed(key)
    --keys are accessed by string name
    if key == 'escape' then
      --built-in function in LÖVE2D to terminate application.
      love.event.quit()
    end
end



--Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise.
function love.draw()
  --Beging rendering at virtual resolution.
    push:apply('start')
    love.graphics.printf(
        'Hello Pong!',          -- text to render
        0,                      -- starting X (0 since we're going to center it based on width)
        VIRTUAL_HEIGHT / 2 - 6,  -- starting Y (halfway down the screen)
        VIRTUAL_WIDTH,           -- number of pixels to center within (the entire screen here)
        'center')               -- alignment mode, can be 'center', 'left', or 'right'
    --End rendering at virtual resolution.
    push:apply('end')
end
