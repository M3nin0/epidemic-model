-- The way of representing the population within a
-- cell via agents was created via the recommendation
-- of the TerraME documentation
-- @link https://github.com/TerraME/terrame/wiki/Paradigms#ABM

local PeopleAgent = Agent{}

PopulationSociety = Society{
    instance = PeopleAgent,
    quantity = 10 * 10 * 5 -- xdim * xdim * elements in cell
}
