--- Generates a vaccination factor by cell location
--- (Described in the article)
--  @arg cell population cell object
function artificialVaccinationArea(cell)
    -- C1
    if cell.x >= 0 and cell.x <= 24 and cell.y >= 0 and cell.y <= 24 then
        return 0.1
    end

    -- C2
    if cell.x >= 0 and cell.x <= 24 and cell.y >= 25 and cell.y <= 49 then
        return 0.3
    end

    -- C3
    if cell.x >= 25 and cell.x <= 49 and cell.y >= 0 and cell.y <= 24 then
        return 0.6
    end

    -- C4
    if cell.x >= 25 and cell.x <= 49 and cell.y >= 25 and cell.y <= 49 then
        return 0.9
    end
end

--- Generates a conection factor by cell location
--- (Described in the article)
--  @arg cell population cell object
function artificialArea(cell)
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
function definePopulationInhomogeneous(cell)
    if cell.population == 'inhomogeneous' then
        -- e^j in article
        cell.population = math.exp(cell.y)
    end
end
