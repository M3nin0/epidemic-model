function VonNeumannNeighborhood(cell, candidate)
    -- same x and y only
    return ((((cell.x - 1) <= candidate.x) or ((cell.x + 1) >= candidate.x)) and (((cell.y + 1) >= candidate.y) or ((cell.y - 1) <= candidate.y)) and (cell.y == candidate.y) or ((cell.x  == candidate.x)))
end

-- ToDo: Cr
function MooreNeighborhood(cell, candidate)
    -- Building the moore matrix
    local a00 = (candidate.x == cell.x - 1) and (candidate.y == cell.y - 1)
    local a01 = (candidate.x == cell.x) and (candidate.y == cell.y - 1)
    local a02 = (candidate.x == cell.x + 1) and (candidate.y == cell.y - 1)
    local a10 = (candidate.x == cell.x - 1) and (candidate.y == cell.y)


    local a11 = (candidate.x == cell.x + 1) and (candidate.y == cell.y)
    local a20 = (candidate.x == cell.x - 1) and (candidate.y == cell.y + 1)
    local a21 = (candidate.x == cell.x) and (candidate.y == cell.y + 1)
    local a22 = (candidate.x == cell.x + 1) and (candidate.y == cell.y + 1)

    return (a00 or a01 or a02 or a10 or a11 or a20 or a21 or a22)
end

function OneNeighborhood(cell, candidate)
    local l0 = (candidate.x > cell.x - 2) and (candidate.x < cell.x + 1)
    local l1 = (candidate.x < cell.x + 2) and (candidate.x > cell.x - 1)
    local l2 = (candidate.y > cell.y - 2 ) and (candidate.y < cell.y + 1)
    local l3 = (candidate.y < cell.y + 2 ) and (candidate.y > cell.y - 1)

    local notEqual = not ((candidate.x == cell.x) and (candidate.y == cell.y))

    return (l0 or l1 or l2 or l3) and notEqual
end

function TwoNeighborhood(cell, candidate)
    return (cell.x == candidate.x and cell.y == candidate.y)
end
