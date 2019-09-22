local Camera, lg = {}, love.graphics

function Camera:new(x, y, w, h, r, s)
    local obj = {}
        obj.x = x
        obj.y = y
        obj.w = w
        obj.h = h
        obj.r = r or 0
        obj.s = s or 1
        obj.cam_x = 0
        obj.cam_y = 0
    return setmetatable(obj, {__index = Camera})
end

function Camera:draw(func)
    local cx = self.x + self.w/2
    local cy = self.y + self.h/2

    lg.setScissor(self.x, self.y, self.w, self.h)
    lg.push()
    lg.translate(cx, cy)
    lg.scale(self.s)
    lg.rotate(self.r)
    lg.translate(self.cam_x, self.cam_y)
    func()
    lg.pop()
    lg.setScissor()
    
    lg.rectangle("line", self.x, self.y, self.w, self.h)
    lg.circle("line", cx, cy, 10)
    lg.line(cx - 10, cy, cx + 10, cy)
    lg.line(cx, cy - 10, cx, cy + 10)
end

function Camera:move(x, y)
    self.cam_x = self.cam_x - x 
    self.cam_y = self.cam_y - y
end

function Camera:zoom(s) 
    self.s = self.s + s
end

function Camera:rotate(r) 
    self.r = self.r + r
end


return Camera
