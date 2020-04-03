require("EpidemicCell")
require("NeighborhoodUtils")
require("PopulationSociety")
require("ConnectionFactorUtils")

-- Random{seed = 777}

EpidemicModel = Model{
    finalTime = 100,

    recoverPortion = 0.4,
    movementFactor = 0.5, -- or 'random', 'artificial-area'
    virulescencePortion = 0.6,
    epidemicCenter = {x = 25, y = 25},

    init = function(model)
        model.cell = EpidemicCell(model.recoverPortion, model.movementFactor,
                                    model.virulescencePortion)

        model.cellularSpace = CellularSpace{
            xdim = 50,
            instance = model.cell,
            infectedInSpace = function(cellularSpace)
				local result = 0

				forEachCell(cellularSpace, function(cell)
					result = result + cell:infectedInCell()
				end)

				return result
            end,
            healthyInSpace = function(cellularSpace)
				local result = 0

				forEachCell(cellularSpace, function(cell)
					result = result + cell:healthyInCell()
				end)
				return result
            end,
            recoveredInSpace = function(cellularSpace)
				local result = 0

				forEachCell(cellularSpace, function(cell)
					result = result + cell:recoveredInCell()
				end)
				return result
            end
        }
        model.cellularSpace:createNeighborhood{
            strategy = "mxn",
            filter = VonNeumannNeighborhood,
            weight = threeWay
        }

        model.cellularSpace:get(
                model.epidemicCenter.x,
                model.epidemicCenter.y).cellPopulation = {healthy = 0.7, infected = 0.3, recovered = 0}

        model.env = Environment{PopulationSociety, model.cellularSpace}
        model.env:createPlacement{max=100}

        model.map = Map{
            target = model.cellularSpace,
            select = "infectedInCell",
            min = 0,
            max = 1,
            slices = 10,
            color = {"white", "black"}
       }

       model.chart = Chart {
            target = model.cellularSpace,
            select = {"healthyInSpace", "infectedInSpace", "recoveredInSpace"},
            color = {"blue", "red", "green"}
        }

        model.timer = Timer{
            Event{action = model.map},
            Event{action = model.chart},
            Event{action = model.cellularSpace}
        }
    end
}

EpidemicModel{finalTime=100}:run()
