local OShape = require("OShape")
local LShape = require("LShape")
local TShape = require("TShape")
local IShape = require("IShape")

local grid = {}
local gridWidth = 12
local gridHeight = 21
local squareSize = 29

local normalTimePerTick = 0.2
local fastTimePerTick = 0.05
local timePerTick = normalTimePerTick
local timeForNextTick = timePerTick

local isGameOver = false;

local currentShape = OShape.new(grid)

function setupGame()
    for y = 1, gridHeight do
        grid[y] = {}
        for x = 1, gridWidth do
            grid[y][x] = 0
        end
    end
end

function love.load()
    love.window.setMode(360, 630, {resizable=false})
    love.graphics.setFont(love.graphics.newFont(24))
    setupGame()
    refreshBoard()
end

function love.update(dt)
    if timeForNextTick <= 0 then
        nextTick()
        timeForNextTick = timePerTick + timeForNextTick
    end
    timeForNextTick = timeForNextTick - dt
end

function love.draw()
    for y = 1, gridHeight do
        for x = 1, gridWidth do
            if grid[y][x] ~= 0 then
                if grid[y][x] == 1 then
                    love.graphics.setColor(44, 44, 44)
                elseif grid[y][x] == 2 then
                    love.graphics.setColor(0, 255, 0)
                end
            love.graphics.rectangle('fill', (x - 1) * (squareSize + 1), (y - 1) * (squareSize + 1), squareSize, squareSize)
            end
        end
    end
    love.graphics.setColor(222, 222, 222)
    love.graphics.rectangle('fill', 0, 600, 360, 30)

    if isGameOver then
        love.graphics.setColor(255, 0, 0)
        love.graphics.print("Game over", 110, 300)
        love.graphics.print("Press space to try again", 35, 330)
    end
end

function love.keypressed(key)
    if key == "left" then
        currentShape.moveLeft()
    elseif key == "right" then
        currentShape.moveRight()
    elseif key == "down" then
        timePerTick = fastTimePerTick
    elseif key == "space" then
        if not isGameOver then
            currentShape.rotate()
        else
            restartGame()
        end
    end
    refreshBoard()
end

function love.keyreleased(key)
    if key == "down" then
        timePerTick = normalTimePerTick
    end
end

function nextTick()
    if isGameOver then
        return
    end
    currentShape.fall()
    checkForFullRow()
    refreshBoard()
end

function refreshBoard()
    if isGameOver then
        return
    end
    for y = 1, gridHeight do
        for x = 1, gridWidth do
            if grid[y][x] == 2 then
                grid[y][x] = 0
            end
        end
    end

    if currentShape.segmentList[1].isActive then
        for i = 1, #currentShape.segmentList do
            grid[currentShape.segmentList[i].y][currentShape.segmentList[i].x] = 2
        end
    else
        for i = 1, #currentShape.segmentList do
            grid[currentShape.segmentList[i].y][currentShape.segmentList[i].x] = 1
        end
        checkForGameOver()
        currentShape = getNextShape()
        refreshBoard()
    end
end

function checkForFullRow()
    for y = 1, gridHeight do
        for x = 1, gridWidth do
            if grid[y][x] ~= 1 then
                break
            end
            if x == gridWidth then
                removeFullRow(y)
            end
        end
    end
end

function removeFullRow(fullRowY)
    for y = fullRowY, 2, -1 do
        for x = 1, gridWidth do
            grid[y][x] = grid[y - 1][x]
        end
    end
end

function checkForGameOver()
    for x = 1, gridWidth do
        if grid[1][x] == 1 then
            gameOver()
        end
    end
end

function gameOver()
    isGameOver = true
end

function restartGame()
    setupGame()
    currentShape = getNextShape()
    isGameOver = false
end

function getNextShape()
    local number = math.random(1, 4)
    local shape
    if number == 1 then
        shape = OShape.new(grid)
    end
    if number == 2 then
        shape = LShape.new(grid)
    end
    if number == 3 then
        shape = TShape.new(grid)
    end
    if number == 4 then
        shape = IShape.new(grid)
    end
    return shape
end