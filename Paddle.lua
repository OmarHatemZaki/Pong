Paddle = Class{}

--[[
    The `init` function on our class is called just once, when the object
    is first created. Used to set up all variables in the class and get it
    ready for use.
    Our Paddle should take an X and a Y, for positioning, as well as a width
    and height for its dimensions.
    Note that `self` is a reference to *this* object, whichever object is
    instantiated at the time this function is called. Different objects can
    have their own x, y, width, and height values, thus serving as containers
    for data. In this sense, they're very similar to structs in C.
]]

function Paddle:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dy = 0 -- will be equal to PADDLE_SPEED
end

--This took some time to think through, but it is actually quite simple.
function Paddle:update(dt)
  if self.dy < 0 and self.y > 0 then
    self.y = self.y + self.dy * dt
  elseif self.dy > 0 and self.y < VIRTUAL_HEIGHT - self.height then
    self.y = self.y + self.dy * dt
  end
end

--direct call to render the ball.
function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
