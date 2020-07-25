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

--speed at which the paddles will move, will be multiplied by dt in update
PADDLE_SPEED = 200


--Runs when the game first starts up, only once; used to initialize the game.
function love.load()

  --This function overrides the default bilinear interpolation to a
  --less blurry filter, that is nearest neighbour.
  --This keeps us consitent with the crisp pixelated approach.
  love.graphics.setDefaultFilter('nearest', 'nearest')

  --more "retro-looking" font that is included in the game's directory.
  --the function takes the font and size
  --and outputs the font in an object format that can be later used.
  smallFont = love.graphics.newFont('font.ttf', 8)

  --larger font for drawing scores on the screen
  bigFont = love.graphics.newFont('font.ttf', 32)

  --Assigns the font object we just imported as LÖVE2D's active font
  --notice that LÖVE2D can only handle one font at a time,
  --a font object is immutable.
  love.graphics.setFont(smallFont)

  --This initlizes our virtual resolution, which will be rendered inside our
  --actual window no matter its dimensions;
  --replaces our typical love.window.setmode()
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    --initializaing scores for players, they will be displayed on screen later
    player1Score = 0
    player2Score = 0

    --paddle positions on the Y axis (they can only move up and down)
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50
end

--Took me a while to get my head around the dt concept, understood it from this
--amazing link: https://www.youtube.com/watch?v=C1_2XlPE6s8
function love.update(dt)

  --Player 1 movment
  if love.keyboard.isDown('w') and player1Y > 0  then
    player1Y = player1Y - PADDLE_SPEED * dt
  elseif love.keyboard.isDown('s') and player1Y < VIRTUAL_HEIGHT -20 then
    player1Y = player1Y + PADDLE_SPEED * dt
  end

  --player 2 movement
  if love.keyboard.isDown('up') and player2Y > 0  then
    player2Y = player2Y - PADDLE_SPEED * dt
  elseif love.keyboard.isDown('down') and player2Y < VIRTUAL_HEIGHT -20 then
    player2Y = player2Y + PADDLE_SPEED * dt
  end
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
    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(bigFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 -50,
    VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
    VIRTUAL_HEIGHT / 3)

    --paddles are simply rectangles we draw on the screen at certain points,
    --as is the ball
    --yes the circle is a rectangle hehe
    --but its so small that you won't be able to tell the difference.
    --it also adds to the pixlated aesthetic.

    --render left paddle
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    --render right paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    --render ball in the center
    love.graphics.rectangle('fill', (VIRTUAL_WIDTH / 2) - 2, (VIRTUAL_HEIGHT / 2) - 2, 4, 4)

    --End rendering at virtual resolution.
    push:apply('end')
end
