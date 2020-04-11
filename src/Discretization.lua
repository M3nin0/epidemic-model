function discretizeInfected(infectedInCell)
    return (100 * infectedInCell) / 100;
end

function discretizeRecovered(recoveredInCell)
    return (100 * recoveredInCell) / 100;
end

function discretizeHealthy(healthyInCell, dInfected, dRecovered)
    return 1 - dInfected - dRecovered;
end
