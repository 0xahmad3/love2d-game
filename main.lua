local w = 1000
local h = 1000
love.window.setMode(w, h)
local grid = {cameraSpeed=0,yoffset = 0}
local ball = {
  x = w/2,
  y = h/2,
  size = 20,
  vy = 0,
  speed = 300,
  jumpForce = -300,
  yground = h,
}
local size = 100
function generateColor()
  math.randomseed(os.time())
  for i=0,size do
    grid[i] = {}

    for k =0,size do
      local r = math.random(0,(size-k)*4)/size
      -- r = (math.floor(r))/10
      grid[i][k] = r
    end
  end
end
local points = {}
function grid:loadGrid()
  -- local points = {table.unpack({})}

  for i=0, size, 1 do
    local xoffset = i*25
    local drawx =  xoffset
    points[i]= {}
    for k=0, size, 1 do
      local yoffset = k * 25
      local drawy = -10*size + yoffset
      points[i][k] = {x = drawx,y = drawy}
      -- print(points[i][k].x, points[i][k].y)
      -- print(#points, #points[0] , 37*37)

  end

end

end
function grid:drawGrid()
  for i=0, size, 1 do
    -- local xoffset = i*25
    for k=0, size,1 do
      -- local yoffset = k*25
      local randomNumber = grid[i][k]
      local bluecolor = 0
      if randomNumber <0.07 then
        bluecolor=1
      end
      love.graphics.setColor( randomNumber,randomNumber*0.50, bluecolor - randomNumber)
      -- print("AT DRAWING AREA ",self.yoffset)
      love.graphics.rectangle("line", points[i][k].x , points[i][k].y, 20, 20)
    end
  end
end

function grid:updateGrid(dt)
  if ball.y < h/4 then
    for i=0, size, 1 do
      for k=0,size,1 do
        points[i][k].y = points[i][k].y +155 *dt
      end
    end
    ball.y = ball.y + 155 * dt
  end
  -- temporary code( there will be a red barrier in the ground if you touch it you lose)
    if ball.y > 3*h/4 then
      for y=0, size, 1 do
        for j=0,size,1 do
          points[y][j].y = points[y][j].y -155 *dt
        end
      end
      ball.y = ball.y - 10 * dt
    end
  end
function ball:draw()
  love.graphics.setColor(1,1, 1)
  -- love.graphics.setLineWidth(6)
  love.graphics.rectangle("fill", self.x-self.size/2, self.y - self.size/2,self.size, self.size)
end
local playeronGround = false
function ball:checkBallonGrid()
  local r
  local left   = self.x - self.size/2
  local right  = self.x + self.size/2
  local bottom = self.y + self.size/2
  self.yground = h
  for i=0,size do
    -- local xoffset = i*25
    for k =0,size do
      local xGrid = points[i][k].x
      -- local yoffset = k*25
      local  yGrid = points[i][k].y
      r = grid[i][k]
      if r < 0.07 then
        local overlapX =
        right > xGrid and
        left < xGrid + 20
        if overlapX and bottom >= yGrid -5 and bottom <= yGrid -5 + 20 then
          self.yground = yGrid -5
          playeronGround = true
          break
        end
      end
    end
  end
end
function ball:update(dt)
  local gravity = 500
  local dx=0
  local dy=0
  self.vy = self.vy + gravity *dt
  self.y = self.y + self.vy *dt
  if love.keyboard.isDown("d") then
    dx = dx + self.speed *dt
  end
  if love.keyboard.isDown("a") then
    dx = dx - self.speed *dt
  end
  if love.keyboard.isDown("s") then
    dy = dy + self.speed * dt
  end
  ball:checkBallonGrid()

  if self.y + self.size/2> self.yground then
      self.y = self.yground-self.size/2
    -- self.y = self.yground
    self.vy = 0
    playeronGround = true
  end

  if self.x + dx - self.size/2>0 and self.x + dx +self.size/2 <w then
    self.x = self.x + dx
  end
  if self.y + dy - self.size/2>0 and self.y + dy + self.size/2<h then
    self.y = self.y + dy
  end
end
function love.keypressed(key)
  if key == "w" and playeronGround then
    ball.vy = ball.jumpForce
    playeronGround = false
  end
end
function love.load()
  grid:loadGrid()
  generateColor()
end
function love.draw()
  grid:drawGrid()
  ball:draw()
end
function love.update(dt)
  grid:updateGrid(dt)
  ball:update(dt)
  if love.keyboard.isDown("r") then
    generateColor()
  end
end
