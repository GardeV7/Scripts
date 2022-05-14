const LEVEL_HEIGHT = 4
const WALL_THICKNESS = 3
const WALL_LENGTH = 10

player.onChat("come", function() {
    agent.teleportToPlayer()
})

player.onChat("build", function () {
    buildCastle()
})

function turnBack() {
    agent.turnLeft()
    agent.turnLeft()
}

function moveToFrontGate() {
    agent.setAssist(PLACE_ON_MOVE, false)
    agent.move(UP, 1)
    agent.move(LEFT, WALL_LENGTH + 1)
    agent.setAssist(PLACE_ON_MOVE, true)
}

function moveToNextLayer() {
    agent.setAssist(PLACE_ON_MOVE, false)
    agent.move(LEFT, 1)
    agent.move(DOWN, LEVEL_HEIGHT)
    agent.setAssist(PLACE_ON_MOVE, true)
}

function moveToNextWall() {
    agent.setAssist(PLACE_ON_MOVE, false)
    agent.move(FORWARD, WALL_LENGTH)
    agent.turnRight()
    agent.move(FORWARD, WALL_THICKNESS + 1)
    agent.setAssist(PLACE_ON_MOVE, true)
}

function moveToTower() {
    agent.setAssist(PLACE_ON_MOVE, false)
    agent.move(BACK, 1)
    agent.turnRight()
    agent.move(FORWARD, 1)
    agent.setAssist(PLACE_ON_MOVE, true)
}

function moveDownFromTower() {
    agent.setAssist(PLACE_ON_MOVE, false)
    agent.move(BACK, 1)
    agent.move(DOWN, LEVEL_HEIGHT * 2 + 1)
    agent.turnLeft()
    agent.move(FORWARD, 1)
    agent.setAssist(PLACE_ON_MOVE, true)
}

function moveToStartMoat() {
    agent.setAssist(PLACE_ON_MOVE, false)
    agent.move(BACK, 4)
    agent.move(DOWN, 1)
    agent.setAssist(PLACE_ON_MOVE, true)
}

function moveToNextMoatLayer() {
    agent.setAssist(PLACE_ON_MOVE, false)
    agent.move(FORWARD, 2)
    agent.move(RIGHT, 2)
    agent.move(DOWN, 1)
    agent.setAssist(PLACE_ON_MOVE, true)
}

function moveToBridge() {
    agent.setAssist(PLACE_ON_MOVE, false)
    agent.move(FORWARD, WALL_LENGTH + WALL_THICKNESS * 3)
    agent.turnRight()
    agent.move(FORWARD, 9)
    agent.move(UP, 1)
    agent.turnLeft()
    agent.setAssist(PLACE_ON_MOVE, true)
}

function buildCastle() {
    agent.setAssist(DESTROY_OBSTACLES, true)
    agent.move(DOWN, 1)
    agent.setAssist(PLACE_ON_MOVE, true)
    buildFloor()
    moveToFrontGate()
    buildWallWithGate()
    moveToTower()
    buildTower()
    moveDownFromTower()
    moveToNextWall()
    buildWallWithWindow()
    moveToTower()
    buildTower()
    moveDownFromTower()
    moveToNextWall()
    buildWallWithTwoWindows()
    moveToTower()
    buildTower()
    moveDownFromTower()
    moveToNextWall()
    buildWallWithWindow()
    moveToTower()
    buildTower()
    moveDownFromTower()
    moveToStartMoat()
    makeMoat()
    moveToNextMoatLayer()
    makeMoat()
    moveToBridge()
    buildBridge()
}

function buildFloor() {
    for(let i = 0; i < WALL_LENGTH; i++) {
        agent.setItem(PLANKS_DARK_OAK, 64, 1)
        agent.move(FORWARD, WALL_LENGTH - 1)
        if(i % 2) {
            agent.move(LEFT, 1)
            turnBack()
        } else {
            agent.move(RIGHT, 1)
            turnBack()
        }
    }
}

function buildWallWithWindow() {
    for(let i = 0; i < WALL_THICKNESS; i++) {
        agent.setItem(SANDSTONE, 64, 1)
        agent.setItem(GLASS, 64, 2)
        for(let j = 0; j < LEVEL_HEIGHT; j++) {
            if(j == 1 || j == 2) {
                agent.move(FORWARD, 4)
                agent.setSlot(2)
                agent.move(FORWARD, 2)
                agent.setSlot(1)
                agent.move(FORWARD, 3)
            } else {
                agent.move(FORWARD, 9)
            }
            agent.move(UP, 1)
            turnBack()
        }
        moveToNextLayer()
    }
}

function buildWallWithTwoWindows() {
    for(let i = 0; i < WALL_THICKNESS; i++) {
        agent.setItem(SANDSTONE, 64, 1)
        agent.setItem(GLASS, 64, 2)
        for(let j = 0; j < LEVEL_HEIGHT; j++) {
            if(j == 1 || j == 2) {
                agent.move(FORWARD, 2)
                agent.setSlot(2)
                agent.move(FORWARD, 2)
                agent.setSlot(1)
                agent.move(FORWARD, 2)
                agent.setSlot(2)
                agent.move(FORWARD, 2)
                agent.setSlot(1)
                agent.move(FORWARD, 1)
            } else {
                agent.move(FORWARD, 9)
            }
            agent.move(UP, 1)
            turnBack()
        }
        moveToNextLayer()
    }
}

function buildWallWithGate() {
    for(let i = 0; i < WALL_THICKNESS; i++) {
        agent.setItem(SANDSTONE, 64, 1)
        agent.setItem(NETHER_BRICK_FENCE, 64, 2)
        for(let j = 0; j < LEVEL_HEIGHT; j++) {
            if(j == 0 || j == 1 || j == 2) {
                agent.move(FORWARD, 3)
                agent.setSlot(2)
                agent.move(FORWARD, 4)
                agent.setSlot(1)
                agent.move(FORWARD, 2)
            } else {
                agent.move(FORWARD, 9)
            }
            agent.move(UP, 1)
            turnBack()
        }
        moveToNextLayer()
    }
}

function buildTower() {
    for(let i = 0; i < LEVEL_HEIGHT * 2; i++) {
        agent.setItem(CHISELED_SANDSTONE, 64, 1)
        for(let j = 0; j < 4; j++) {
            agent.move(FORWARD, WALL_THICKNESS - 1)
            agent.turnRight()
        }
        agent.move(UP, 1)
    }

    agent.setItem(CHISELED_SANDSTONE, 64, 1)
    for(let i = 0; i < 4; i++) {
        agent.move(FORWARD, 1)
        agent.setAssist(PLACE_ON_MOVE, false)
        if(i == 3) {
            agent.move(UP, 1)
        }
        agent.move(FORWARD, 1)
        agent.turnRight()
        agent.setAssist(PLACE_ON_MOVE, true)
    }
}

function makeMoat() {
    for(let i = 0; i < WALL_THICKNESS; i++) {
        for(let j = 0; j < 4; j++) {
            for(let h = 0; h < WALL_LENGTH + 1 + WALL_THICKNESS * 2 + i * 2; h++) {
                agent.setItem(WATER_BUCKET, 1, 1)
                agent.move(FORWARD, 1)
            }
            agent.turnRight()
        }
        if (i < WALL_THICKNESS - 1) {
            agent.setItem(WATER_BUCKET, 1, 1)
            agent.move(LEFT, 1)
            agent.setItem(WATER_BUCKET, 1, 1)
            agent.move(BACK, 1)
        }
    }
}

function buildBridge() {
    for(let i = 0; i < 4; i++) {
        agent.setItem(PLANKS_SPRUCE, 64, 1)
        agent.move(FORWARD, WALL_THICKNESS - 1)
        if(i % 2) {
            agent.move(LEFT, 1)
            turnBack()
        } else {
            agent.move(RIGHT, 1)
            turnBack()
        }
    }
}
