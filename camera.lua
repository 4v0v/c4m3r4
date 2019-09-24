local Camera, lg, rand = {}, love.graphics, love.math.random

local function _smooth(a, b, s, dt) return a + (b - a) * (1.0 - math.exp(-s * dt)) end
local function _rand(x) return love.math.noise(love.math.random()) - 0.5 end

function Camera:new(x, y, w, h, r, s)
    local obj = {}
        obj.x = x
        obj.y = y
        obj.w = w
        obj.h = h
        obj.r = r or 0
        obj.s = s or 1
        obj.cam = { x = 0, y = 0, r = r or 0, s = s or 1, tx = 0, ty = 0, ts = s or 1, m = "default", sm = "default", sv = 10, ssv = 10 }
        obj.shk = { s = 0, r = 0, z = 0 }
    return setmetatable(obj, {__index = Camera})
end

function Camera:update(dt)
    if     self.cam.m == "default"  then self.cam.x, self.cam.y = self.cam.tx, self.cam.ty
    elseif self.cam.m == "smooth"   then self.cam.x, self.cam.y = _smooth(self.cam.x, self.cam.tx, self.cam.sv, dt), _smooth(self.cam.y, self.cam.ty, self.cam.sv, dt) end
    if     self.cam.sm == "default" then self.cam.s = self.cam.ts
    elseif self.cam.sm == "smooth"  then self.cam.s = _smooth(self.cam.s, self.cam.ts, self.cam.ssv, dt) end
    if math.abs(self.shk.s) > 5   then self.shk.s = _smooth(self.shk.s, 0, 5, dt) else self.shk.s = 0 end
    if math.abs(self.shk.r) > 0.1 then self.shk.r = _smooth(self.shk.r, 0, 5, dt) else self.shk.r = 0 end
    if math.abs(self.shk.z) > 0.1 then self.shk.z = _smooth(self.shk.z, 0, 5, dt) else self.shk.z = 0 end
end

function Camera:draw(func)
    local cx, cy = self.x + self.w/2, self.y + self.h/2
    lg.setScissor(self.x, self.y, self.w, self.h)
    lg.push()
    lg.translate(cx, cy)
    lg.scale(self.cam.s + _rand()*self.shk.z)
    lg.rotate(self.cam.r + _rand()*self.shk.r)
    lg.translate(-self.cam.x, -self.cam.y)
    lg.translate(_rand()*self.shk.s, _rand()*self.shk.s)
        func()
        lg.circle("line", self.cam.tx, self.cam.ty, 10)
        lg.line(self.cam.tx - 10, self.cam.ty, self.cam.tx + 10, self.cam.ty)
        lg.line(self.cam.tx, self.cam.ty - 10, self.cam.tx, self.cam.ty + 10)
    lg.pop()
    lg.setScissor()

    lg.rectangle("line", self.x, self.y, self.w, self.h)
    lg.circle("line", cx, cy, 10)
    lg.line(cx - 10, cy, cx + 10, cy)
    lg.line(cx, cy - 10, cx, cy + 10)
end

function Camera:shake(s, r, z) self.shk.s, self.shk.r, self.shk.z = s or 0 ,r or 0 ,z or 0 end
function Camera:attach(x, y) self.cam.tx, self.cam.ty = x or self.cam.tx, y or self.cam.ty end
function Camera:zoom(s) self.cam.ts = s end

function Camera:getPosition() return self.cam.x, self.cam.y end
function Camera:getTargetPosition() return self.cam.tx, self.cam.ty end
function Camera:getX() return self.cam.x end
function Camera:getY() return self.cam.y end
function Camera:getTargetX() return self.cam.tx end
function Camera:getTargetY() return self.cam.ty end
function Camera:getAngle() return self.cam.r end
function Camera:getScale() return self.cam.s end
function Camera:getTargetScale() return self.cam.ts end

function Camera:setLinearValue(lv) self.cam.lv = lv end
function Camera:setSmoothValue(sv) self.cam.sv = sv end
function Camera:setScale(s) self.cam.s, self.cam.ts = s, s end
function Camera:setAngle(r) self.cam.r = r end
function Camera:setMode(m) self.cam.m = m end
function Camera:setScaleMode(m) self.cam.sm = m end
function Camera:setPosition(x, y) self.cam.x, self.cam.tx, self.cam.y, self.cam.ty = x or self.cam.x, x or self.cam.tx, y or self.cam.y, y or self.cam.ty end
function Camera:setX(x) self.cam.x, self.cam.tx = x or self.cam.x, x or self.cam.tx end
function Camera:setY(y) self.cam.y, self.cam.ty = y or self.cam.y, y or self.cam.ty end

function Camera:screenToCam(x, y) end
function Camera:camToScreen(x, y) end
function Camera:getMousePosition() return self:camToScreen(love.mouse.getPosition()) end

return Camera
