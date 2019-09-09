-------------------------------
-- Based on "classic" by kikito : https://github.com/kikito/gamera && "STALKER-X" by adnzzzzZ : https://github.com/adnzzzzZ/STALKER-X
-- MIT License
-- Copyright (c) 2018, 4v0v
-------------------------------

local Camera = {}

-------------------------------

local lg = love.graphics
local function _smooth(a, b, speed, dt) return a + (b - a) * (1.0 - math.exp(-speed * dt)) end
local function _linear(x,y, speed, dt)
	local d = math.sqrt(x*x+y*y)
	local dt_speed = math.min(speed * dt, d)
	if d > 0 then x,y = x/d, y/d end
	return x * dt_speed, y * dt_speed
end

-------------------------------

function Camera:__call()
	local obj = {}
		obj.x, obj.y   = 0, 0
		obj.w, obj.h   = lg.getWidth(), lg.getHeight()
		obj.s, obj.r   = 1, 0
		obj.sh         = {x = 0, y = 0}
		obj.cx, obj.cy = obj.w/2, obj.h/2
		obj.target = {
			x = obj.x,
			y = obj.y,
			s = obj.s,
			r = obj.r
		}
		obj.smooth, obj.rot_smooth, obj.scale_smooth = 5, 5, 5
		obj.linear, obj.rot_linear, obj.scale_linear = 700, 200, 1
		obj.mode, obj.rot_mode, obj.scale_mode       = "default", "default", "default"
		obj.shaking = {
			shaking = 0,
			rot     = 0,
			zoom    = 0,
			shear_x = 0,
			shear_y = 0
		}
    return setmetatable(obj, {__index = Camera})
end

function Camera:update(dt)
    if     self.mode       == "smooth"  then self.x, self.y = _smooth(self.x, self.target["x"], self.smooth, dt), _smooth(self.y, self.target["y"], self.smooth, dt)
    elseif self.mode       == "linear"  then local _x, _y =  _linear(self.target["x"] - self.x, self.target["y"] - self.y, self.linear, dt); self.x, self.y = self.x + _x, self.y + _y
    elseif self.mode       == "default" then self.x, self.y = self.target["x"], self.target["y"] end
    
    if     self.rot_mode   == "smooth"  then self.r = _smooth(self.r, self.target["r"], self.rot_smooth, dt)
    elseif self.rot_mode   == "linear"  then self.r = self.r + _linear(self.target["r"] - self.r, 0, self.rot_linear, dt)
    elseif self.rot_mode   == "default" then self.r = self.target["r"] end
    
    if     self.scale_mode == "smooth"  then self.s = _smooth(self.s, self.target["s"], self.scale_smooth, dt)
    elseif self.scale_mode == "linear"  then self.s = self.s + _linear(self.target["s"] - self.s, 0, self.scale_linear, dt)
    elseif self.scale_mode == "default" then self.s = self.target["s"] end
    
    if math.abs(self.shaking["shaking"]) > 5   then self.shaking["shaking"] = _smooth(self.shaking["shaking"], 0, 5, dt) else self.shaking["shaking"] = 0 end
    if math.abs(self.shaking["rot"]    ) > 0.1 then self.shaking["rot"]     = _smooth(self.shaking["rot"], 0, 5, dt)     else self.shaking["rot"]     = 0 end
    if math.abs(self.shaking["zoom"]   ) > 0.1 then self.shaking["zoom"]    = _smooth(self.shaking["zoom"], 0, 5, dt)    else self.shaking["zoom"]    = 0 end
    if math.abs(self.shaking["shear_x"]) > 0.1 then self.shaking["shear_x"] = _smooth(self.shaking["shear_x"], 0, 5, dt) else self.shaking["shear_x"] = 0 end
    if math.abs(self.shaking["shear_y"]) > 0.1 then self.shaking["shear_y"] = _smooth(self.shaking["shear_y"], 0, 5, dt) else self.shaking["shear_y"] = 0 end
end

function Camera:draw(func)
    lg.push()
    lg.translate(self.cx, self.cy)
    lg.rotate(math.rad(self.r + (math.random()-.5)*self.shaking["rot"]))
    lg.scale(self.s + (math.random()-.5)*self.shaking["zoom"])
    lg.shear(self.sh["x"] + (math.random()-.5)*self.shaking["shear_x"], self.sh["y"] + (math.random()-.5)*self.shaking["shear_y"])
    lg.translate(-self.x, -self.y)
    lg.translate((math.random()-.5)*self.shaking["shaking"], (math.random()-.5)*self.shaking["shaking"])
            func()
    lg.pop()
end

-------------------------------

function Camera:set_smooth_speed(speed) self.smooth = speed; return self end
function Camera:set_smooth_rot_speed(speed) self.rot_smooth = speed; return self end
function Camera:set_smooth_zoom_speed(speed) self.scale_smooth = speed; return self end
function Camera:set_linear_speed(speed) self.linear = speed; return self end
function Camera:set_linear_rot_speed(speed) self.rot_linear = speed; return self end
function Camera:set_linear_zoom_speed(speed) self.scale_linear = speed; return self end
function Camera:set_mode(mode) self.mode = mode or "default"; return self end
function Camera:set_rotate_mode(mode) self.rot_mode = mode or "default"; return self end
function Camera:set_zoom_mode(mode) self.scale_mode = mode or "default"; return self end

-------------------------------

function Camera:shake(s, r, z, sx, sy)
    self.shaking["shaking"] = s or 0
    self.shaking["rot"]     = r or 0
    self.shaking["zoom"]    = z or 0
    self.shaking["shear_x"] = sx or 0
    self.shaking["shear_y"] = sy or 0
    return self
end
function Camera:move_to(x, y) self.target["x"], self.target["y"] = x, y; return self end
function Camera:rotate_to(r) self.target["r"] = r; return self end
function Camera:zoom_to(s) self.target["s"] = s; return self end
function Camera:move(x, y) self.target["x"] = self.target["x"] + x; self.target["y"] = self.target["y"] + y return self end
function Camera:zoom(s) self.target["s"] = self.target["s"] + s return self end
function Camera:rotate(r) self.target["r"] = self.target["r"] + r return self end
function Camera:get_position() return self.x, self.y end

-------------------------------

-- function Camera:world_to_cam(x,y)
-- 	local c, s = math.cos(math.rad(self.r)), math.sin(math.rad(self.r))
-- 	x, y = x - self.x, y - self.y
-- 	x, y = c*x - s*y, s*x + c*y
-- 	return x*self.scale + self.w/2, y*self.scale + self.h/2
-- end
function Camera:cam_to_world(x, y)
    local c, s = math.cos(math.rad(-self.r)), math.sin(math.rad(-self.r))
    x, y = (x - self.w/2)/self.s, (y - self.h/2)/self.s
    x, y = c*x - s*y, s*x + c*y
    return x + self.x, y + self.y
end
function Camera:get_mouse_position() return self:cam_to_world(love.mouse.getPosition()) end

-------------------------------

return setmetatable({}, Camera)
