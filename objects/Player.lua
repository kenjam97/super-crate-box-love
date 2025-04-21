Player = GameObject:extend()

function Player:init(area, x, y, opts)
    Player.super.init(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = 10, 20
    self.area.world:add(self, self.x, self.y, self.w, self.h)

    self.speed = 200
    self.velocity = {
        x = 0,
        y = 0
    }

    self.gravity = 800
    self.jump_force = -360
    self.max_fall_speed = 400
    self.min_jump_force = -150
    self.grounded = false
    self.is_jumping = false

    self.coyote_time = 0.1
    self.time_left_ground = 0
end

function Player:update(dt)
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        self.velocity.x = -self.speed
    elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        self.velocity.x = self.speed
    else
        self.velocity.x = 0
    end

    if self.grounded then
        self.time_left_ground = 0
        self.is_jumping = false
    else
        self.time_left_ground = self.time_left_ground + dt
    end

    self.velocity.y = self.velocity.y + self.gravity * dt

    if self.is_jumping and not input:down('jump') and self.velocity.y < 0 then
        self.velocity.y = math.max(self.velocity.y, self.min_jump_force)
    end

    self.velocity.y = math.min(self.velocity.y, self.max_fall_speed)

    if input:pressed('jump') and (self.grounded or self.time_left_ground < self.coyote_time) then
        self.velocity.y = self.jump_force
        self.grounded = false
        self.is_jumping = true
        self.time_left_ground = self.coyote_time
    end

    local goalX = self.x + self.velocity.x * dt
    local goalY = self.y + self.velocity.y * dt

    local actualX, actualY, collisions, len = self.area.world:move(self, goalX, goalY, function(item, other)
        if other.is_platform then
            if self.velocity.y >= 0 then
                return "slide"
            else
                return "cross"
            end
        end
        return "slide"
    end)

    self.x = actualX
    self.y = actualY

    self.grounded = false
    for i = 1, len do
        local col = collisions[i]
        if col.normal.y < 0 then
            self.grounded = true
            self.velocity.y = 0
            self.y = col.touch.y
        elseif col.normal.y > 0 then
            self.velocity.y = 0
            self.is_jumping = false
        end
    end

    if not self.grounded and self.velocity.y >= 0 then
        local _, _, cols, hitCount = self.area.world:check(self, self.x, self.y + 1)
        for i = 1, hitCount do
            local col = cols[i]
            if col.normal.y < 0 then
                self.grounded = true
                break
            end
        end
    end

    Player.super.update(self, dt)
end

function Player:draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1)
end
