function roundFloat = roundValue(inputFloat, shift)
    roundFloat = int32(inputFloat * shift);
    roundFloat = double(roundFloat) / shift;
end

