Stage = Object:extend()

function Stage:init()
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.main_canvas = love.graphics.newCanvas(gw, gh)

    -- Add walls
    -- Left wall
    self.area:addGameObject("Platform", 0, 0, {
        w = 10,
        h = gh
    })
    -- Right wall
    self.area:addGameObject("Platform", gw - 10, 0, {
        w = 10,
        h = gh
    })

    -- Add platforms according to the layout
    -- Top split platforms
    self.area:addGameObject("Platform", 0, 0, {
        w = gw * 0.35,
        h = 10
    })
    self.area:addGameObject("Platform", gw * 0.65, 0, {
        w = gw * 0.35,
        h = 10
    })

    -- Upper middle platform
    self.area:addGameObject("Platform", gw * 0.25, gh * 0.25, {
        w = gw * 0.5,
        h = 10
    })

    -- Side platforms
    self.area:addGameObject("Platform", 0, gh * 0.5, {
        w = gw * 0.2,
        h = 10
    })
    self.area:addGameObject("Platform", gw * 0.8, gh * 0.5, {
        w = gw * 0.2,
        h = 10
    })

    -- Lower middle platform
    self.area:addGameObject("Platform", gw * 0.3, gh * 0.75, {
        w = gw * 0.4,
        h = 10
    })

    -- Bottom split platforms
    self.area:addGameObject("Platform", 0, gh - 10, {
        w = gw * 0.45,
        h = 10
    })
    self.area:addGameObject("Platform", gw * 0.55, gh - 10, {
        w = gw * 0.45,
        h = 10
    })

    -- Add player last so it appears on top
    self.player = self.area:addGameObject("Player", gw / 2, gh / 2)
    input:bind('f3', function()
        self.player.dead = true
    end)
end

function Stage:update(dt)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw / 2, gh / 2)

    if love.keyboard.isDown("s") then
        camera:shake(4, 60, 1)
    end

    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0, 0, gw, gh)
    self.area:draw()
    camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1) -- Changed from 255,255,255,255 to normalized colors (0-1)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode("alpha")
end
