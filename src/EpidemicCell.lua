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

    forEachNeighbor(cell, function(neighbor, weight)
        -- calculating micra term
        local networkConnectionVirulescence =
                    weight  * neighbor.movementFactor * cell.virulescencePortion

        local tmp = (#neighbor:getAgents() / #cell:getAgents()) * networkConnectionVirulescence
        result = result + (tmp * neighbor.past.cellPopulation.infected)
    end)
    return healthyFactor * result
end


function EpidemicCell(recoverPortion, movementFactor, virulescencePortion)
    return Cell{
        recoverPortion = recoverPortion,
        movementFactor = movementFactor, -- or 'random', 'artificial-area'
        virulescencePortion = virulescencePortion,

        init = function(cell)
            cell.cellPopulation = {healthy = 1, infected = 0, recovered = 0}

            if cell.movementFactor == 'random' then
                cell.movementFactor = Random{min = 0, max = 1}:sample()
            elseif cell.movementFactor == 'artificial-area' then
                cell.movementFactor = artificialArea(cell)
            end
        end,
        execute = function(cell)
            local infectionFactorByConnections = generatesInfectionFactorByConnections(
                                                cell.past.cellPopulation.healthy, cell)

            cell.cellPopulation.infected = ((1 - cell.recoverPortion) * cell.past.cellPopulation.infected) + (cell.virulescencePortion * cell.past.cellPopulation.healthy * cell.past.cellPopulation.infected) + infectionFactorByConnections

            cell.cellPopulation.healthy = cell.past.cellPopulation.healthy - (cell.virulescencePortion * cell.past.cellPopulation.healthy * cell.past.cellPopulation.infected) - infectionFactorByConnections

            cell.cellPopulation.recovered = cell.past.cellPopulation.recovered + (cell.recoverPortion * cell.past.cellPopulation.infected)
        end,
        healthyInCell = function(cell) return cell.cellPopulation.healthy end,
        infectedInCell = function(cell) return cell.cellPopulation.infected end,
        recoveredInCell = function(cell) return cell.cellPopulation.recovered end,
    }
end
