function [childA, childB] = crossOver(geneA, geneB)
    % Init child
    childA = Gene(0, 0);
    childB = Gene(0, 0);

    % Copy the gene sequence
    savedGeneA = geneA.geneStr(10: 17);
    savedGeneB = geneB.geneStr(10: 17);

    % Gene switch
    newGeneA = append(geneA.geneStr(1: 9), savedGeneB, geneA.geneStr(18: 26));
    newGeneB = append(geneB.geneStr(1: 9), savedGeneA, geneB.geneStr(18: 26));
    childA = childA.setGene(newGeneA);
    childB = childB.setGene(newGeneB);
end

