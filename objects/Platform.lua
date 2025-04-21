Platform = GameObject:extend()

function Platform:init(area, x, y, opts)
    Platform.super.init(self, area, x, y, opts)

    -- Set default dimensions if not provided in opts
    self.w = opts.w or 150
    self.h = opts.h or 20

    -- Add the platform to the physics world
    self.area.world:add(self, x, y, self.w, self.h)
end

function Platform:update(dt)
    Platform.super.update(self, dt)
end

function Platform:draw()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1)
end
