function love.load()
    Camera = require("camera")
    lg = love.graphics
    lg.setDefaultFilter("nearest", "nearest")
    lg.setLineStyle("rough")
    W, H = love.graphics.getDimensions()
    worldmap = lg.newImage("world.png")

    cam2 = Camera:new(0, 0, W/2, H, 0, 1)
    cam1 = Camera:new(W/2, 0, W/2, H/2, 0, 0.8)
    cam3 = Camera:new(W/2,  H/2, W/2, H/2, 0.2, 0.2)

    cam1:setMode("smooth")
    cam1:setScaleMode("smooth")
end

function love.update(dt)

    cam1:update(dt)
    cam2:update(dt)
    cam3:update(dt)

    if love.keyboard.isDown("left")  then cam1:attach(cam1:getTargetX() + -500 * dt, _) end
    if love.keyboard.isDown("right") then cam1:attach(cam1:getTargetX() + 500 * dt , _) end    
    if love.keyboard.isDown("up")    then cam1:attach(_ , cam1:getTargetY() + -500 * dt) end
    if love.keyboard.isDown("down")  then cam1:attach(_ , cam1:getTargetY() + 500 * dt) end

    if love.keyboard.isDown("a") then cam1:zoom(2) end
    if love.keyboard.isDown("q") then cam1:zoom(0.5) end

    if love.keyboard.isDown("x") then cam1:setAngle(0.2) end
    if love.keyboard.isDown("w") then cam1:setAngle(-0.5) end

    if love.keyboard.isDown("1") then cam1:shake(50) end
    if love.keyboard.isDown("2") then cam1:shake(_, 1) end
    if love.keyboard.isDown("3") then cam1:shake(_, _, 1) end

    if love.keyboard.isDown("4") then cam1:setPosition(0, 0) end
    if love.keyboard.isDown("5") then cam1:attach(-cam1:getX(), -cam1:getY()) end

    if love.keyboard.isDown("escape") then love.event.quit() end    
end

function love.draw()
    cam1:draw(draw_func)
    cam2:draw(draw_func)
    cam3:draw(draw_func)


    local _x, _y = cam1:camToScreen(0, 0)
    lg.print(_x .. "\n" .. _y)

    -- lg.print(cam1:getX() .. "\n" .. cam1:getY().. "\n" .. cam1:getScale())
end


function draw_func()
    lg.draw(worldmap, 0, 0)
    lg.rectangle("line", 0, 0, 800, 600)
end
