
function onload()
  self.createButton({ click_function = 'onClick_RotateHandsClockwise',
                      label = 'Pass Hand',
                      function_owner = self,
                      position = {0, 2.9, 0},
                      rotation = {0, 0, 0},
                      width = 1100,
                      height = 1100,
                      font_size = 200})

  self.createButton({ click_function = 'setDirectionClockwise',
                      label = '<---',
                      function_owner = self,
                      position = {0.8, 1.3, -3},
                      rotation = {0, 180, 0},
                      scale = {0.5,0.5,0.5},
                      width = 1100,
                      height = 1100,
                      font_size = 400,
                      font_color = {0,0,0,1},
                      color = {1,1,1,1}})

  self.createButton({ click_function = 'setDirectionCounterClockwise',
                      label = '--->',
                      function_owner = self,
                      position = {-0.8, 1.3, -3},
                      rotation = {0, 180, 0},
                      scale = {0.5,0.5,0.5},
                      width = 1100,
                      height = 1100,
                      font_size = 400,
                      font_color = {0,0,0,1},
                      color = {1,1,1,1}})

  self.setName('Pass Hand')


end

function onClick_RotateHandsClockwise()
    local players = getRealSeatedPlayers()
    local playersClockwise = playersClockwise(players)
    --print("DEBUG: Number of seated players: " .. #players)
    --print("DEBUG: Number of players clockwise: " .. #playersClockwise)
    --for i,player in ipairs(playersClockwise) do
    --    print("DEBUG: " .. i .. " : " .. player.color)
    --end
    for i, player in ipairs(playersClockwise) do
        local moveToIndex = 1
        if i == #players
        then
            moveToIndex = 1
        else
            moveToIndex = i + 1
        end
        local moveToPlayer = playersClockwise[moveToIndex]
        local handRotation = moveToPlayer.getHandTransform().rotation
        -- ensure the cards are facing the towards the player
        handRotation.y = handRotation.y + 180
        local handPosition = moveToPlayer.getHandTransform().position
        local cards = player.getHandObjects()
        -- print("DEBUG: Moving cards from " .. i .. " : " .. player.color ..
        -- " to " .. moveToIndex .. " : " .. moveToPlayer.color)
        for i,card in ipairs(cards) do
            card.setPosition(handPosition)
            card.setRotation(handRotation)
        end
    end
end

function onClick_RotateHandsCounterClockwise()
    local players = getRealSeatedPlayers()
    local playersCounterClockwise = playersCounterClockwise(players)
    --print("DEBUG: Number of seated players: " .. #players)
    --print("DEBUG: Number of players clockwise: " .. #playersClockwise)
    --for i,player in ipairs(playersCounterClockwise) do
    --    print("DEBUG: " .. i .. " : " .. player.color)
    --end
    for i, player in ipairs(playersCounterClockwise) do
        local moveToIndex = 1
        if i == #players
        then
            moveToIndex = 1
        else
            moveToIndex = i + 1
        end
        local moveToPlayer = playersCounterClockwise[moveToIndex]
        local handRotation = moveToPlayer.getHandTransform().rotation
        -- ensure the cards are facing the towards the player
        handRotation.y = handRotation.y + 180
        local handPosition = moveToPlayer.getHandTransform().position
        local cards = player.getHandObjects()
        -- print("DEBUG: Moving cards from " .. i .. " : " .. player.color ..
        -- " to " .. moveToIndex .. " : " .. moveToPlayer.color)
        for i,card in ipairs(cards) do
            card.setPosition(handPosition)
            card.setRotation(handRotation)
        end
    end
end

-- getSeatedPlayers() doesn't return the actual Player objects.
-- This function will instead return the 'real' Player objects.
function getRealSeatedPlayers()
    local playerColors = getSeatedPlayers()
    local players = {}
    local newI = 1
    for i, playerColor in pairs(playerColors) do
        if Player[playerColor].getPlayerHand() != nil
        then
            players[newI] = Player[playerColor]
            newI = newI + 1
        end
    end
    return players
end

-- Returns a Table with player angles (in radians) as the keys
function playerAngles(players)
    local angles = {}
    for i, player in pairs(players) do
        angles[getPlayerAngle(player)] = player
    end
    return angles
end

function playersCounterClockwise(players)
    local newPlayers = {}
    local newI = 1
    for i, player in pairsByKeys(playerAngles(players)) do
        newPlayers[newI] = player
        newI = newI + 1
    end
    return newPlayers
end

function playersClockwise(players)
    local newPlayers = {}
    local newI = #players
    for i, player in pairsByKeys(playerAngles(players)) do
        newPlayers[newI] = player
        newI = newI - 1
    end
    return newPlayers
end

function getPlayerAngle(player)
    local hand = player.getPlayerHand()
    --print("DEBUG: Player color: " .. player.color)
    return math.atan2(hand.pos_z, hand.pos_x)
end

-- Copied from LUA docs... returns iterator in order of keys
function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
        table.sort(a, f)
        local i = 0      -- iterator variable
        local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
            else return a[i], t[a[i]]
        end
    end
    return iter
end

function reverseArray(tbl)
  for i=1, math.floor(#tbl / 2) do
    local tmp = tbl[i]
    tbl[i] = tbl[#tbl - i + 1]
    tbl[#tbl - i + 1] = tmp
  end
end

function setDirectionClockwise()
    self.editButton({1, click_function = 'onClick_RotateHandsClockwise'})
    broadcastToAll("Hand Rotation set to Clockwise")
end

function setDirectionCounterClockwise()
    self.editButton({1, click_function = 'onClick_RotateHandsCounterClockwise'})
    broadcastToAll("Hand Rotation set to Counter Clockwise")
end