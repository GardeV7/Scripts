local Shape = require("Shape")
local Segment = require("Segment")
local Helpers = require("Helpers")

local I = {}
I.new = function(gameGrid)
    local self = Shape.new(gameGrid)

    local rotationCounter = 0

    table.insert(self.segmentList, Segment.new(5, 1, true))
    table.insert(self.segmentList, Segment.new(6, 1, true))
    table.insert(self.segmentList, Segment.new(7, 1, true))
    table.insert(self.segmentList, Segment.new(8, 1, true))

    function self.rotate()
        local oldSegments = Helpers.deepcopy(self.segmentList)

        if rotationCounter % 4 == 0 then
            self.segmentList[1].x = self.segmentList[1].x + 2
            self.segmentList[1].y = self.segmentList[1].y - 1
            self.segmentList[2].x = self.segmentList[2].x + 1
            self.segmentList[3].y = self.segmentList[3].y + 1
            self.segmentList[4].x = self.segmentList[4].x - 1
            self.segmentList[4].y = self.segmentList[4].y + 2
        elseif rotationCounter % 4 == 1 then
            self.segmentList[1].x = self.segmentList[1].x + 1
            self.segmentList[1].y = self.segmentList[1].y + 2
            self.segmentList[2].y = self.segmentList[2].y + 1
            self.segmentList[3].x = self.segmentList[3].x - 1
            self.segmentList[4].x = self.segmentList[4].x - 2
            self.segmentList[4].y = self.segmentList[4].y - 1
        elseif rotationCounter % 4 == 2 then
            self.segmentList[1].x = self.segmentList[1].x - 2
            self.segmentList[1].y = self.segmentList[1].y + 1
            self.segmentList[2].x = self.segmentList[2].x - 1
            self.segmentList[3].y = self.segmentList[3].y - 1
            self.segmentList[4].x = self.segmentList[4].x + 1
            self.segmentList[4].y = self.segmentList[4].y - 2
        elseif rotationCounter % 4 == 3 then
            self.segmentList[1].x = self.segmentList[1].x - 1
            self.segmentList[1].y = self.segmentList[1].y - 2
            self.segmentList[2].y = self.segmentList[2].y - 1
            self.segmentList[3].x = self.segmentList[3].x + 1
            self.segmentList[4].x = self.segmentList[4].x + 2
            self.segmentList[4].y = self.segmentList[4].y + 1
        end
        for i = 1, #self.segmentList do
            local posX = self.segmentList[i].x
            local posY = self.segmentList[i].y
            if posY >= #gameGrid or posY < 1 or posX >= #gameGrid[1] + 1 or posX < 1 or gameGrid[posY][posX] == 1 then
                self.segmentList = oldSegments
                break
            end
            if i == #self.segmentList then
                rotationCounter = rotationCounter + 1
            end
        end
    end

    return self
end

return I
