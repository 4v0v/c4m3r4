local Camera, lg = {}, love.graphics

local function _smooth(a, b, speed, dt) return a + (b - a) * (1.0 - math.exp(-speed * dt)) end
local function _lerp(a, b, speed, dt) return a + (b - a) * (speed * dt) end

function Camera:new(x, y, w, h, r, s)
    local obj = {}
        obj.x = x
        obj.y = y
        obj.w = w
        obj.h = h
        obj.r = r or 0
        obj.s = s or 1
        obj.cam = {
            x = 0,
            y = 0,
            r = r or 0,
            s = s or 1,
            tx = 0,
            ty = 0,
        }
        obj.shk = {
            s = 0,
            r = 0,
            z = 0
        }
    return setmetatable(obj, {__index = Camera})
end

function Camera:update(dt)
    -- self.cam.x = self.cam.tx
    -- self.cam.y = self.cam.ty

    self.cam.x = _smooth(self.cam.x, self.cam.tx, 10, dt)
    self.cam.y = _smooth(self.cam.y, self.cam.ty, 10, dt)

    if math.abs(self.shk.s) > 5   then self.shk.s = _smooth(self.shk.s, 0, 5, dt) else self.shk.s = 0 end
    if math.abs(self.shk.r) > 0.1 then self.shk.r = _smooth(self.shk.r, 0, 5, dt) else self.shk.r = 0 end
    if math.abs(self.shk.z) > 0.1 then self.shk.z = _smooth(self.shk.z, 0, 5, dt) else self.shk.z = 0 end
end

function Camera:draw(func)
    local cx, cy = self.x + self.w/2, self.y + self.h/2
    lg.setScissor(self.x, self.y, self.w, self.h)
    lg.push()
    lg.translate(cx, cy)
    lg.scale(self.cam.s + (math.random()-.5)*self.shk.z)
    lg.rotate(self.cam.r + (math.random()-.5)*self.shk.r)
    lg.translate(-self.cam.x, -self.cam.y)
    lg.translate((math.random()-.5)*self.shk.s, (math.random()-.5)*self.shk.s)
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
function Camera:move(x, y) self.cam.tx, self.cam.ty = self.cam.tx + x, self.cam.ty - y end
function Camera:zoom(s) self.cam.s = self.cam.s + s end
function Camera:rotate(r) self.cam.r = self.cam.r + r end
function Camera:getPosition() return self.cam.x, self.cam.y end
function Camera:getX() return self.cam.x end
function Camera:getY() return self.cam.y end
function Camera:getAngle() return self.cam.r end
function Camera:getScale() return self.cam.s end

return Camera
