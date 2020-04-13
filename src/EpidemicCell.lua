require("Utils")

--- Generates a conection factor by cell location
--- (Described in the article)
--  @arg cell population cell
local function artificialArea(cell)
    -- Artificial Area 1
    if cell.x >= 0 and cell.x <= 24 and cell.y >= 0 and cell.y <= 24 then
        return 0.6
    end

    -- Artificial Area 2
    if cell.x >= 0 and cell.x <= 24 and cell.y >= 25 and cell.y <= 49 then
        return 1
    end

    -- Artificial Area 3
    if cell.x >= 25 and cell.x <= 49 and cell.y >= 0 and cell.y <= 24 then
        return 0
    end

    -- Artificial Area 4
    if cell.x >= 25 and cell.x <= 49 and cell.y >= 25 and cell.y <= 49 then
        return 0.3
    end
end

--- Defines the population of a cell based on its Y position
--- (Described in the article)
--  @arg cell cell from cellular space
local function definePopulationInhomogeneous(cell)
    if cell.population == 'inhomogeneous' then
        -- e^j in article
        cell.population = math.exp(cell.y)
    end
end

local function generatesInfectionFactorByConnections(healthyFactor, cell)
    local result = 0
    local connectionFactor = cell.connectionFactor

    definePopulationInhomogeneous(cell)
    if cell.connectionFactor == 'artificial-area' then
        connectionFactor = artificialArea(cell)
    end

    forEachNeighbor(cell, function(neighbor)
        definePopulationInhomogeneous(neighbor)

        -- calculating micra term
        local networkConnectionVirulescence =
            connectionFactor  * neighbor.movementFactor * cell.virulescencePortion

        local tmp = (neighbor.population / cell.population) * networkConnectionVirulescence
        result = result + (tmp * neighbor.past.infected)
    end)

    return healthyFactor * result
end


function EpidemicCell(recoverPortion, movementFactor,
                        virulescencePortion, connectionFactor,
                        vaccination, population)
    return Cell{
        healthy = 1,
        infected = 0,
        recovered = 0,
        population = population,
        vaccination = vaccination,
        recoverPortion = recoverPortion,
        movementFactor = movementFactor,
        connectionFactor = connectionFactor, -- or 'artificial-area'
        virulescencePortion = virulescencePortion,
        init = function(cell)
        end,
        execute = function(cell)
            local infectionFactorByConnections = generatesInfectionFactorByConnections(
                                                            cell.past.healthy, cell)

             cell.infected = ((1 - cell.recoverPortion) * cell.past.infected)
             cell.infected = cell.infected + (cell.virulescencePortion * cell.past.healthy * cell.past.infected)
             cell.infected = cell.infected + infectionFactorByConnections

             cell.healthy = cell.past.healthy - (cell.past.healthy * cell.vaccination)
             cell.healthy = cell.healthy - (cell.virulescencePortion * cell.past.healthy * cell.past.infected)
             cell.healthy = cell.healthy - infectionFactorByConnections

             cell.recovered = cell.past.recovered + (cell.recoverPortion * cell.past.infected)
             cell.recovered = cell.recovered + cell.vaccination * cell.past.healthy
        end
    }
end
