function random() 
  math.randomseed(os.clock() * 100000000000)
  math.random(); math.random()
  math.random(); math.random()
  return math.random()
end

function independentBernoulliRandomVariable(p)
  if random() <= p then
    return 1
  else
    return 0
  end
end

function binomialDistribution(n, p, size)
  local binomialValues = {};
  
  for i=1,size do
    binomialValues[i] = 0
    for j=1,n do
      binomialValues[i] = binomialValues[i] + independentBernoulliRandomVariable(p)
    end
  end
  
  return binomialValues
end
