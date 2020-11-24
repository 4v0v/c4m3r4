local Camera = {}

local function _smooth(a, b, s, dt) return a + (b - a) * (1.0 - math.exp(-s * dt)) end
local function _rand(x) return love.math.noise(love.math.random()) - 0.5 end

function Camera:new(x, y, w, h, s)
	local obj = {}
		obj.x = x or 0
		obj.y = y or 0
		obj.w = w or love.graphics.getWidth()
		obj.h = h or love.graphics.getHeight()
		obj.cam = { x = 0, y = 0, s = s or 1, target_x = 0, target_y = 0, target_s = s or 1, sv = 10, ssv = 10 }
		obj.shk = { s = 0, r = 0, tick = 1/60, timer = 0, xrs = 0, yrs = 0, rr = 0}
	return setmetatable(obj, {__index = Camera})
end

function Camera:update(dt)
	self.cam.x = _smooth(self.cam.x, self.cam.target_x, self.cam.sv, dt)
	self.cam.y = _smooth(self.cam.y, self.cam.target_y, self.cam.sv, dt)
	self.cam.s = _smooth(self.cam.s, self.cam.target_s, self.cam.ssv, dt)

	self.shk.timer = self.shk.timer + dt
	if self.shk.timer > self.shk.tick then 
		if self.shk.s ~= 0 then self.shk.xrs, self.shk.yrs = _rand()*self.shk.s, _rand()*self.shk.s else self.shk.xrs, self.shk.yrs = 0, 0 end
		if self.shk.r ~= 0 then self.shk.rr = _rand()*self.shk.r else self.shk.rr = 0 end
		self.shk.timer = self.shk.timer - self.shk.tick
	end
	if math.abs(self.shk.s) > 5  then self.shk.s = _smooth(self.shk.s, 0, 5, dt) else	if self.shk.s ~= 0 then self.shk.s = 0 end end
	if math.abs(self.shk.r) > 0.1 then self.shk.r = _smooth(self.shk.r, 0, 5, dt) else if self.shk.r ~= 0 then self.shk.r = 0 end end
end

function Camera:draw(func)
	love.graphics.push()
	love.graphics.translate(self.x + self.w/2, self.y + self.h/2)
	love.graphics.scale(self.cam.s)
	love.graphics.rotate(self.shk.rr)
	love.graphics.translate(-self.cam.x + self.shk.xrs, -self.cam.y + self.shk.yrs)
	func()
	love.graphics.pop()
end

function Camera:follow(x, y) self.cam.target_x, self.cam.target_y = x or self.cam.target_x, y or self.cam.ty end
function Camera:zoom(s) self.cam.target_s = s end
function Camera:shake(s, r) self.shk.s, self.shk.r = s or 0 ,r or 0 end

function Camera:getPosition() return self.cam.x, self.cam.y, self.cam.target_x, self.cam.ty end
function Camera:getScale() return self.cam.s, self.cam.target_s end

function Camera:setSmoothness(sv) self.cam.sv = sv end
function Camera:setScaleSmoothness(sv) self.cam.ssv = ssv end
function Camera:setScale(s) self.cam.s, self.cam.target_s = s, s end
function Camera:setPosition(x, y) 
	self.cam.x, self.cam.target_x = x or self.cam.x, x or self.cam.target_x
	self.cam.y, self.cam.target_y = y or self.cam.y, y or self.cam.target_y
end

function Camera:camToScreen(x, y)
	x, y = x - self.cam.x, y - self.cam.y
	x, y = x * self.cam.s, y * self.cam.s
	x, y = x + self.w / 2 + self.x, y + self.h / 2 + self.y
	return x, y
end

function Camera:screenToCam(x, y)
	x, y = x - self.w / 2 - self.x, y - self.h / 2 - self.y
	x, y = x / self.cam.s, y / self.cam.s
	x, y = x + self.cam.x, y + self.cam.y
	return x, y
end

function Camera:getMousePosition() return
	self:screenToCam(love.mouse.getPosition()) 
end

return setmetatable({}, {__call = Camera.new})
