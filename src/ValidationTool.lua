require("Discretization")

--- Calculates the reproductive number, used to determine whether the infected
--- population reaches its neighbors
-- @arg v Virulence
-- @arg healthy Number of healthy in epidemic center
-- @arg recoverPortion Recover factor of virus
function reproductiveNumber(v, healthy, recoverPortion)
    return (v * healthy) / recoverPortion
end

--- Calculates the reproductive number, used to determine whether the infected
--- population reaches its neighbors. Verify if true or false
-- @arg v Virulence
-- @arg healthy Number of healthy in epidemic center
-- @arg recoverPortion Recover factor of virus
function reproductiveNumberIsValid(v, healthy, recoverPortion)
    return reproductiveNumber(v, healthy, recoverPortion) < 1
end

--- Equation 13 described in automaton paper
-- @arg nO Population of epidemic center (O)
-- @arg nN Population of north neighbor (N) of epidemic center
-- @arg cN Connection factor from O to N
-- @arg mN Movement Factor from O to N
-- @arg v Virulence
function equation13Paper(nO, nN, cN, mN, v)
    return nN / (100 * nO * cN * mN * v)
end

--- Generates the number of infecteds in north neighbor in T = 1
-- @arg infected Number of infecteds in epidemic center
-- @arg nO Population of epidemic center (O)
-- @arg nN Population of north neighbor (N) of epidemic center
-- @arg cN Connection factor from O to N
-- @arg mN Movement Factor from O to N
-- @arg v Virulence
function numberOfInfectedInT1(infected, nO, nN, cN, mN, v)
    return (nO / nN) * cN * mN * v * infected;
end

--- Checks whether the parameters will produce an epidemic
-- @arg dInfected Discretized number of infecteds in epidemic center
-- @arg nO Population of epidemic center (O)
-- @arg nN Population of north neighbor (N) of epidemic center
-- @arg cN Connection factor from O to N
-- @arg mN Movement Factor from O to N
-- @arg v Virulence
function willThereBeInfecteds(dInfected, nO, nN, cN, mN, v)
    -- local infectedIsValidEq = nN / (100 * nO * cN * mN * v)
    return dInfected >= equation13Paper(nO, nN, cN, mN, v)
end

-- Tests to verify parameters
local nInfectedT1 = numberOfInfectedInT1(0.7, 100, 100, 1, 0.5, 0.6);
local dInfectedT1 = discretizeInfected(nInfectedT1);

print(dInfectedT1)
print(equation13Paper(100, 100,  1, 0.5, 0.6))
print(willThereBeInfecteds(dInfectedT1, 100, 100,  1, 0.5, 0.6))
