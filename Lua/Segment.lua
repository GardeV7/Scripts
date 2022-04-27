local Segment = {}
Segment.new = function(x, y, active)
    local self = {}

    self.x = x
    self.y = y
    self.isActive = active

    return self
end

return Segment
