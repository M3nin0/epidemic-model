require("Utils")
require("ArtificialContext")


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
            -- define vaccination factor by cell quadrant
            if (cell.vaccination == 'artificial-vac') then
                cell.vaccination = artificialVaccinationArea(cell)
            end
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
