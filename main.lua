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

  -- velocity and position variables for our ball when play starts
  ballX = VIRTUAL_WIDTH / 2 - 2
  ballY = VIRTUAL_HEIGHT / 2 - 2

  -- "seed" the RNG so that calls to random are always random
  -- use the current time, since that will vary on startup every time
  math.randomseed(os.time())

  -- math.random returns a random value between the left and right number
  ballDX = math.random(2) == 1 and 100 or -100
  ballDY = math.random(-100, 100)

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

  --paddle positions on the Y axis (they can only move up and down)
  player1Y = 30
  player2Y = VIRTUAL_HEIGHT - 50

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

  if gameState == 'play' then
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt
  end
end


--[[
    Keyboard handling, called by LÖVE2D each frame;
    passes in the key we pressed so we can access its string format.
    Unlike love.keyboard.isDown, love.keypressed checks for one click, and
    doesn't follow a continous press.
]]
function love.keypressed(key)
    --keys are accessed by string name
  if key == 'escape' then
      --built-in function in LÖVE2D to terminate application.
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
          ballX = VIRTUAL_WIDTH / 2 - 2
          ballY = VIRTUAL_HEIGHT / 2 - 2

          player1Score = 0
          player2Score = 0

          player1Y = 30
          player2Y = VIRTUAL_HEIGHT - 50

          ballDX = math.random(2) == 1 and 100 or -100
          ballDY = math.random(-100, 100)
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
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    --render right paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    --render ball in the center
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    --End rendering at virtual resolution.
    push:apply('end')
end
