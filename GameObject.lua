GameObject = Object:extend()

function GameObject:init(area, x, y, opts)
    local opts = opts or {}
    if opts then
        for k, v in pairs(opts) do
            self[k] = v
        end
    end

    self.area = area
    self.x, self.y = x, y
    self.id = UUID()
    self.dead = false
    self.timer = Timer()
end

function GameObject:update(dt)
    if self.timer then
        self.timer:update(dt)
    end
end

function GameObject:draw()
end

function GameObject:destroy()
    self.timer:clear()
    if self.area.world:hasItem(self) then
        self.area.world:remove(self)
    end
end
