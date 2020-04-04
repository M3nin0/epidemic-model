-- Connection factors described in article
-- "Modeling epidemics using cellular automata"

--- Generates a conection factor by a three way of connections
--- (e.g. Airplane, Train, Car and Bus)
function threeWay()
    return 1
end

--- Generates a conection factor by a two way of connections
--- (e.g. Airplane, Train)
function twoWay()
    return 0.6
end

--- Generates a conection factor by a one way of connection
--- (e.g. Airplane)
function oneWay()
    return 0.3
end

--- Generates a conection factor without connection way
function noWay()
    return 0
end

function artificialWay()
    return 'artificial-area'
end

--- Generates a random connection factor way (Considering 0, 1, 2 or 3 ways)
function randomWay()
    return Random{
        noWay(), oneWay(), twoWay(), threeWay()
    }:sample()
end
