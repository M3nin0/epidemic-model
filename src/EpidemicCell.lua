--- Generates a conection factor by cell location
--- (Described in article)
--  @arg cell population cell
local function artificialArea(cell)

    -- Artificial Area 1
    if cell.x >= 1 and cell.x <= 25 and cell.y >= 1 and cell.y <= 25 then
        return 0.6
    end

    -- Artificial Area 2
    if cell.x >= 1 and cell.x <= 25 and cell.y >= 26 and cell.y <= 50 then
        return 1
    end

    -- Artificial Area 3
    if cell.x >= 26 and cell.x <= 50 and cell.y >= 1 and cell.y <= 25 then
        return 0
    end

    -- Artificial Area 4
    if cell.x >= 26 and cell.x <= 50 and cell.y >= 26 and cell.y <= 50 then
        return 0.3
    end
end


local function generatesInfectionFactorByConnections(healthyFactor, cell)
    local result = 0

    forEachNeighbor(cell, function(neighbor)
        -- calculating micra term
        local networkConnectionVirulescence =
            cell.connectionFactor  * neighbor.movementFactor * cell.virulescencePortion

        local tmp = (neighbor.population / cell.population) * networkConnectionVirulescence
        result = result + (tmp * neighbor.past.infected)
    end)

    return healthyFactor * result
end


function EpidemicCell(recoverPortion, movementFactor,
                        virulescencePortion, connectionFactor)
    return Cell{
        healthy = 1,
        infected = 0,
        recovered = 0,
        population = 100,
        recoverPortion = recoverPortion,
        movementFactor = movementFactor, -- or 'random', 'artificial-area'
        connectionFactor = connectionFactor,
        virulescencePortion = virulescencePortion,
        init = function(cell)
            -- ToDo: Movement factor
            -- ToDo: population type
        end,
        execute = function(cell)
            local infectionFactorByConnections = generatesInfectionFactorByConnections(
                                                            cell.past.healthy, cell)

             cell.infected = ((1 - cell.recoverPortion) * cell.past.infected)
             cell.infected = cell.infected + (cell.virulescencePortion * cell.past.healthy * cell.past.infected)
             cell.infected = cell.infected + infectionFactorByConnections

             cell.healthy = cell.past.healthy - (cell.virulescencePortion * cell.past.healthy * cell.past.infected)
             cell.healthy = cell.healthy - infectionFactorByConnections

             cell.recovered = cell.past.recovered + (cell.recoverPortion * cell.past.infected)
        end
    }
end
