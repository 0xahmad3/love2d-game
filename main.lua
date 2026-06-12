local w = 1000
local h = 1000
love.window.setMode(w, h)
local grid = {}
local ball = {
  x = w/2,
  y = h/2,
  size = 20,
  vy = 0,
  speed = 300,
  jumpForce = 200,
  yground = h,
}
function generateGrid()
  math.randomseed(os.time())
  for i=0,37 do
    grid[i] = {}

    for k =0,37 do
      local r = math.random()*10
      r = math.floor(r)/10
      r = r+0.1
      grid[i][k] = r
    end
  end
end
function drawGrid()
  for i=0, 37, 1 do
    local xoffset = i*25
    for k=0, 37,1 do
      local yoffset = k*25
      local randomNumber = grid[i][k]
      local bluecolor = 0

      if randomNumber == 0.1 then
        bluecolor=1
      end
      love.graphics.setColor(0,  randomNumber, bluecolor)
      love.graphics.rectangle("line", (w/35)+xoffset , (h/35)+ yoffset, 20, 20)
    end
  end
end
function ball:draw()
  love.graphics.setColor(1,1, 1)
  -- love.graphics.setLineWidth(6)
  love.graphics.rectangle("fill", self.x-self.size/2, self.y - self.size/2,self.size, self.size)
end
function ball:checkBallonGrid()
  local r
  local left   = self.x - self.size/2
  local right  = self.x + self.size/2
  local bottom = self.y + self.size/2
  self.yground = h
  for i=0,37 do
    local xoffset = i*25
    local xGrid = w/35 + xoffset
    for k =0,37 do
      local yoffset = k*25
      local  yGrid = h/35 + yoffset
      r = grid[i][k]
      if r == 0.1 then

        local overlapX =
        right > xGrid and
        left < xGrid + 20

        if overlapX and bottom >= yGrid and bottom <= yGrid + 20 then
          self.yground = yGrid
          break
        end
      end
    end
  end

end
function ball:update(dt)
  local gravity = 800
  local dx=0
  local dy=0
  if love.keyboard.isDown("d") then
    dx = dx + self.speed *dt
  end
  if love.keyboard.isDown("a") then
    dx = dx - self.speed *dt
  end
  if love.keyboard.isDown("w") then
    dy = dy - self.speed * dt
  end
  if love.keyboard.isDown("s") then
    dy = dy + self.speed * dt
  end
  self.vy = self.vy + gravity *dt
  self.y = self.y + self.vy *dt
  ball:checkBallonGrid()

  if self.y + self.size/2> self.yground then
      self.y = self.yground-self.size/2
    -- self.y = self.yground

    self.vy = 0
  end

  if self.x + dx - self.size/2>0 and self.x + dx +self.size/2 <w then
    self.x = self.x + dx
  end
  if self.y + dy - self.size/2>0 and self.y + dy + self.size/2<h then
    self.y = self.y + dy
  end
end
function love.load()
  generateGrid()
end
function love.draw()
  drawGrid()
  ball:draw()
end
function love.update(dt)
  ball:update(dt)
  if love.keyboard.isDown("r") then
    generateGrid()
  end
end
