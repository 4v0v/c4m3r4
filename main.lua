function love.load()
    Camera = require("camera")
    lg = love.graphics
    lg.setDefaultFilter("nearest", "nearest")
    lg.setLineStyle("rough")
    W, H = love.graphics.getDimensions()
    worldmap = lg.newImage("world.png")

    cam1 = Camera:new(0, 0, W/2, H, 0, 0.5)
    cam2 = Camera:new(W/2, 0, W/2, H/2, 0.2, 1)
    cam3 = Camera:new(W/2,  H/2, W/2, H/2, 0.2, 0.2)
end

function love.update(dt)

    if love.keyboard.isDown("left") then cam1:move(-10 , 0) end
    if love.keyboard.isDown("right") then cam1:move(10 , 0) end

    if love.keyboard.isDown("a") then cam1:zoom(0.01) end
    if love.keyboard.isDown("q") then cam1:zoom(-0.01) end

    if love.keyboard.isDown("w") then cam1:rotate(0.01) end
    if love.keyboard.isDown("x") then cam1:rotate(-0.01) end
end

function love.draw()
    cam1:draw(draw_func)
    cam2:draw(draw_func)
    cam3:draw(draw_func)
end


function draw_func()
    lg.draw(worldmap, 0, 0)
end