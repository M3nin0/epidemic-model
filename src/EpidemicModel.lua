require("Utils")
require("EpidemicCell")
require("ConnectionFactorUtils")


EpidemicModel = Model{
    time = 1,
    finalTime = 60,

    -- Model params
    recoverPortion = 0.4,
    movementFactor = 0.5,
    connectionFactor = oneWay(),
    virulescencePortion = 0.6,
    epidemicCenter = {x = 25, y = 25},
    init = function(self)
        self.cell = EpidemicCell(self.recoverPortion, self.movementFactor,
                            self.virulescencePortion, self.connectionFactor)

        self.cs = CellularSpace{
            xdim = 50,
            instance = self.cell
        }
        self.cs:createNeighborhood{
            strategy = "vonneumann" -- or "moore"
        }

        -- Defining a epidemic center
        local epidemicCenter = self.cs:get(self.epidemicCenter.x ,
                                                    self.epidemicCenter.y)
        epidemicCenter.healthy = 0.7
        epidemicCenter.infected = 0.3

        -- model visual objects
        self.map = Map{
            target = self.cs,
            select = "infected",
            min = 0,
            max = 1,
            slices = 5,
            color = {"white", "black"}
        }
        self.chart = Chart {
            target = self.cs,
            select = {"healthy", "infected", "recovered"},
            color = {"blue", "red", "green"}
        }

        self.timer = Timer{
            Event{action = self},
            Event{action = self.cs},
            Event{action = self.map},
            Event{action = self.chart}
        }
    end,
    execute = function (model) -- to save model figures
        model.map:save("images/epidemicmodel_t" .. model.time .. ".png")
        model.time = model.time + 1
    end
}

EpidemicModel:run()
