local Shape = require("Shape")
local Segment = require("Segment")

local O = {}
O.new = function(gameGrid)
    local self = Shape.new(gameGrid)

    table.insert(self.segmentList, Segment.new(6, 1, true))
    table.insert(self.segmentList, Segment.new(7, 1, true))
    table.insert(self.segmentList, Segment.new(6, 2, true))
    table.insert(self.segmentList, Segment.new(7, 2, true))

    function self.rotate()
        return
    end

    return self
end

return O
