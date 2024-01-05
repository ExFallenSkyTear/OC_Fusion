function isMouseOver(x, y, horizontalLowerBound, horizontalUpperBound, verticalLowerBound, verticalUpperBound)
    return isInRange(x, horizontalLowerBound, horizontalUpperBound) and isInRange(y, verticalLowerBound, verticalUpperBound)
end

function isInRange(x, lowerBound, upperBound)
    return lowerBound <= x and x <= upperBound
end