import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics
local playerSprite = nil

local counter = 0

local startX = 0
local startY = 0

local map = {
            1,1,1,1,1,1,1,1,1,1,1,1,
            1,0,0,0,0,0,1,0,0,3,0,1,
            1,1,1,0,0,0,1,0,0,0,0,1,
            1,0,1,0,0,0,0,0,1,1,1,1,
            1,0,0,0,0,0,0,0,0,0,2,1,
            1,1,1,1,1,1,1,1,1,1,1,1
            }

function gameSetUp()
    
    local backgroundImage = gfx.image.new( "images/background" )
    assert( backgroundImage )

    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            backgroundImage:draw( 0, 0 )
        end
    )

    pd.setMenuImage(pauseMenuImage)
    
end

function loadPlayer(x, y)
    local playerImage = gfx.image.new("images/player")
    assert (playerImage)

    local pauseMenuImage = gfx.image.new("images/pause-menu")
    assert (pauseMenuImage)

    playerX = 32 * x - 8
    playerY = 32 * y - 8

    playerSprite = gfx.sprite.new(playerImage)
    playerSprite:moveTo(playerX, playerY)
    playerSprite:add()
end

gameSetUp()


function pd.update()
    gfx.sprite.update()

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.drawText("10", 34, 217)
    -- pd.drawFPS(0, 0)

end

function loadMapSwitchCase(value)
    local cases = {
        [0] = function() print("Floor") end,
        [1] = function() print("Wall") end,
        [2] = function() print("Player") end,
        [3] = function() print("Key") end,
        -- Add more cases as needed
        default = function() print("Default case") end
    }
    
    -- Execute the corresponding case or the default case
    local case = cases[value] or cases.default
    case()
end

function loadMap()
    for i = 1, #map do
        -- 2 = player spawn. If it's 2, calculate the spawn location and pass in the X, Y to the loadPlayer function
        loadMapSwitchCase(map[i])
        if (map[i] == 2)
        then
            if (i > 12)
            then
                -- mod 12 to find X placement. If mod 12 = 0, then use 12 to find column
                startX = i % 12
                if (startX == 0)
                then
                    startX = 12
                end
                -- divide by 12 and round up to find Y. Finds row
                startY = math.ceil(i / 12)
            else
                startX = i
                startY = 1
            end
            loadPlayer(startX, startY)
        end
    end
end

loadMap()

local myInputHandlers = {
    AButtonDown = function()
        print("A Button pressed!")
    end,

    BButtonDown = function()
        print("B Button pressed!")
    end,

    downButtonDown = function()
        if ((playerSprite.y + 32 < 210))
        then
            playerSprite:moveBy(0,32)
        end
        print(playerSprite:getPosition())
    end,

    leftButtonDown = function()
        if ((playerSprite.x - 32 > 20))
        then
            playerSprite:moveBy(-32,0)
        end
        print(playerSprite:getPosition())
    end,

    upButtonDown = function()
        if ((playerSprite.y - 32 > 20))
        then
            playerSprite:moveBy(0,-32)
        end
        print(playerSprite:getPosition())
    end,

    rightButtonDown = function()
        if ((playerSprite.x + 32 < 390))
        then
            playerSprite:moveBy(32,0)
        end
        print(playerSprite:getPosition())
    end
}

playdate.inputHandlers.push(myInputHandlers)