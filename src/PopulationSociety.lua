-- The way of representing the population within a
-- cell via agents was created via the recommendation
-- of the TerraME documentation
-- @link https://github.com/TerraME/terrame/wiki/Paradigms#ABM

local PeopleAgent = Agent{}

PopulationSociety = Society{
    instance = PeopleAgent,
    quantity = 50 * 50 * 100 -- xdim * xdim * elements in cell
}
