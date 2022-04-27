local Segment = require("Segment")

local Shape = {}
Shape.new = function(gameGrid)
    local self = {}

    self.segmentList = {}

    function self.moveLeft()
        for i = 1, #self.segmentList do
            local posX = self.segmentList[i].x
            local posY = self.segmentList[i].y
            if posX <= 1 or gameGrid[posY][posX - 1] == 1 then
                return
            end
            if i == #self.segmentList then
                for j = 1, #self.segmentList do
                    self.segmentList[j].x = self.segmentList[j].x - 1
                end
            end
        end
    end

    function self.moveRight()
        for i = 1, #self.segmentList do
            local posX = self.segmentList[i].x
            local posY = self.segmentList[i].y
            if posX >= #gameGrid[1] or gameGrid[posY][posX + 1] == 1 then
                return
            end
            if i == #self.segmentList then
                for j = 1, #self.segmentList do
                    self.segmentList[j].x = self.segmentList[j].x + 1
                end
            end
        end
    end

    function self.fall()
        if not self.segmentList[1].isActive then
            return
        end

        for i = 1, #self.segmentList do
            local posX = self.segmentList[i].x
            local posY = self.segmentList[i].y
            if posY >= #gameGrid - 1 or gameGrid[posY + 1][posX] == 1 then
                for j = 1, #self.segmentList do
                    self.segmentList[j].isActive = false
                end
                break
            end

            if i == #self.segmentList then
                for j = 1, #self.segmentList do
                    self.segmentList[j].y = self.segmentList[j].y + 1
                end
            end
            
        end
    end

    return self
end

return Shape
