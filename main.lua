--[[
    Omar Hatem
    Pong Remake
    Based on the GD50 2020 class
    Instructor: Colton Ogden
]]

--Push is a library that enables virtualization. It allows us to
--draw at a virtual resolution instead of whatever our actual resolution is.
--it is used to provide a more retro aesthetic
--https://github.com/Ulydev/push
push = require 'push'

--Actual window size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--Virtual window size to imitate the low res feel of retro games
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


--Runs when the game first starts up, only once; used to initialize the game.
function love.load()

  --This function overrides the default bilinear interpolation to a
  --less blurry filter, that is nearest neighbour.
  --This keeps us consitent with the crisp pixelated approach.
  love.graphics.setDefaultFilter('nearest', 'nearest')

  --more "retro-looking" font that is included in the game's directory.
  --this function outputs the font in an object format that can be later used.
  retroFont = love.graphics.newFont('font.ttf', 8)

  --Assigns the font object we just imported as LÖVE2D's active font
  --notice that LÖVE2D can only handle one font at a time,
  --a font object is immutable.
  love.graphics.setFont(retroFont)

  --This initlizes our virtual resolution, which will be rendered inside our
  --actual window no matter its dimensions;
  --replaces our typical love.window.setmode()
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

--[[
    Keyboard handling, called by LÖVE2D each frame;
    passes in the key we pressed so we can access its string format.
]]
function love.keypressed(key)
    --keys are accessed by string name
    if key == 'escape' then
      --built-in function in LÖVE2D to terminate application.
      love.event.quit()
    end
end



--[[
    Called after update by LÖVE2D,
    used to draw anything to the screen, updated or otherwise.
]]
function love.draw()
  --Beging rendering at virtual resolution.
    push:apply('start')

    --This function clears the screen with the selected color.
    --In this case, its a grey similar to the original grey color of Pong.
    --It now only accepts values from 0 to 1 instead of 0 to 255 like before.
    love.graphics.clear(0.16, 0.17, 0.20)

    --Draw welcome msg at the top of the screen, inputs respectively are;
    --(text to render, starting x, starting y,
    --number of pixels to center align within (The entire screen here),
    --alignment mode, can be 'center', 'left', 'right')
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    --paddles are simply rectangles we draw on the screen at certain points,
    --as is the ball
    --yes the circle is a rectangle hehe
    --but its so small that you won't be able to tell the difference.
    --it also adds to the pixlated aesthetic.

    --render left paddle
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    --render right paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

    --render ball in the center
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH / 2) - 2, (VIRTUAL_HEIGHT / 2) - 2, 4, 4)

    --End rendering at virtual resolution.
    push:apply('end')
end
