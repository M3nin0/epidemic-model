function VonNeumannNeighborhood(cell, candidate)
    -- same x and y only
    return ((((cell.x - 1) <= candidate.x) or ((cell.x + 1) >= candidate.x)) and (((cell.y + 1) >= candidate.y) or ((cell.y - 1) <= candidate.y)) and (cell.y == candidate.y) or ((cell.x  == candidate.x)))
end
