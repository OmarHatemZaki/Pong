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

--turns lua into an object oriented machine
--https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

--These are now possible to create thanks to 'class' library
--Now instead of having a main with 800 lines of code, our code is organized.
require 'Paddle'
require 'Ball'

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

  -- "seed" the RNG so that calls to random are always random
  -- uses the UNIX EPOCH, since that will vary on startup every time
  math.randomseed(os.time())

  --more "retro-looking" font that is included in the game's directory.
  --the function takes the font and size
  --and outputs the font in an object format that can be later used.
  smallFont = love.graphics.newFont('font.ttf', 8)

  --larger font for drawing scores on the screen
  bigFont = love.graphics.newFont('font.ttf', 32)

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

  --Initintiating players and balls.
  player1 = Paddle(10, 30, 5, 20)
  player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20)

  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)


  --using strings now for states, but might want to consider switching to
  --enums in lua, which isn't exactly direct like in C#/java
  --These might help;
  --https://www.lexaloffle.com/bbs/?tid=29891
  --https://unendli.ch/posts/2016-07-22-enumerations-in-lua.html
  gameState = 'start'

end

--Took me a while to get my head around the dt concept, understood it from this
--amazing link: https://www.youtube.com/watch?v=C1_2XlPE6s8
function love.update(dt)

  --might consider adding an extra condition where if neither button
  --is keypressed then force dy to equal zero
  --Player 1 movment
  if love.keyboard.isDown('w') then
    player1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    player1.dy = PADDLE_SPEED
  else
    player1.dy = 0
  end

  --player 2 movement
  if love.keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    player2.dy = PADDLE_SPEED
  else
    player2.dy = 0
  end

  if gameState == 'play' then
    ball:update(dt)
  end

  player1:update(dt)
  player2:update(dt)
end


--[[
    Keyboard handling, called by LÖVE2D each frame;
    passes in the key we pressed so we can access its string format.
    Unlike love.keyboard.isDown, love.keypressed checks for one click, and
    doesn't follow a continous press.
]]
function love.keypressed(key)

  if key == 'escape' then
      love.event.quit()
    elseif  key == 'return' then
        if gameState == 'start' then
          gameState = 'play'
        else
          gameState = 'start'

          --Recalling these to reinitialize the game
          --considered calling the whole love.load()
          --but it also reinitializes the window,
          --need to think about it a bit
          --suggested solution; create a function and add all these variables.
          --then call that function both in load and here.
          --this way, the window intilization and anything we don't want
          --to re-initialize will be left alone in love.load.
          ball:reset()

        end
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

    --Assigns one of the font objects we imported as LÖVE2D's active font
    --notice that LÖVE2D can only handle one font at a time,
    --a font object is immutable.
    love.graphics.setFont(smallFont)
    --Draw welcome msg at the top of the screen, inputs respectively are;
    --(text to render, starting x, starting y,
    --number of pixels to center align within (The entire screen here),
    --alignment mode, can be 'center', 'left', 'right')
    if gameState == 'start' then
      love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
        elseif gameState == 'play' then
          love.graphics.setFont(smallFont)
          love.graphics.printf('PONG', 0, 20, VIRTUAL_WIDTH, 'center')

          love.graphics.setFont(bigFont)
          love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 -50,
          VIRTUAL_HEIGHT / 3)
          love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
          VIRTUAL_HEIGHT / 3)
      end
    --paddles are simply rectangles we draw on the screen at certain points,
    --as is the ball
    --yes the circle is a rectangle hehe
    --but its so small that you won't be able to tell the difference.
    --it also adds to the pixlated aesthetic.

    --render left paddle
    player1:render()

    --render right paddle
    player2:render()

    --render ball in the center
    ball:render()

    --End rendering at virtual resolution.
    push:apply('end')
end
