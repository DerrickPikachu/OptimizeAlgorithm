function newGene = mutation(gene)
    % Get random number between [1, 26]
    randNum = floor(mod((rand * 1000), 26)) + 1;
    geneSeq = gene.geneStr;
    newGene = Gene(0, 0);
    
    if (geneSeq(randNum) == '0')
        geneSeq(randNum) = '1';
    else
        geneSeq(randNum) = '0';
    end
    
    newGene = newGene.setGene(geneSeq);
end

