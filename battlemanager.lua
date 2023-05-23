--battlemanager.lua

BattleManager = {}
BattleManager.__index = BattleManager

function BattleManager.new()
    local self = setmetatable({}, BattleManager)
    self.players = {}  -- the players in the game
    self.enemies = {}  -- the enemies in the game
    return self
end

function BattleManager:addPlayer(player)
    table.insert(self.players, player)
end

function BattleManager:addEnemy(enemy)
    table.insert(self.enemies, enemy)
end

-- Call this when a player attacks
function BattleManager:playerAttack(player, attack)
    -- for each enemy in the game
    for _, enemy in ipairs(self.enemies) do
        -- apply the attack
        attack:execute(player, enemy)
    end
end

-- Call this when an enemy attacks
function BattleManager:enemyAttack(enemy, attack)
    -- for each player in the game
    for _, player in ipairs(self.players) do
        -- apply the attack
        attack:execute(enemy, player)
    end
end
