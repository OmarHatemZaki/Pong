Ball = Class{}

--initializes the ball variables.
function Ball:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height

  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-100, 100)
end

--used to hard reset ball in different game states.
function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2

  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-100, 100)
end

--used to update and move ball in play state.
function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

--direct call to render the ball.
function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
