function newGene = mutation(gene)
    % Get boundary
    ubx = gene.upperBoundX;
    lbx = gene.lowerBoundX;
    uby = gene.upperBoundY;
    lby = gene.lowerBoundY;

    % Get random number between [1, 26]
    randNum = floor(mod((rand * 1000), 26)) + 1;
    geneSeq = gene.geneStr;
    newGene = Gene(0, 0, ubx, lbx, uby, lby);
    
    if (geneSeq(randNum) == '0')
        geneSeq(randNum) = '1';
    else
        geneSeq(randNum) = '0';
    end
    
    newGene = newGene.setGene(geneSeq);
end

