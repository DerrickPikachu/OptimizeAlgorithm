function [childA, childB] = crossOver(geneA, geneB)
    % Get boundary
    ubx = geneA.upperBoundX;
    lbx = geneA.lowerBoundX;
    uby = geneA.upperBoundY;
    lby = geneA.lowerBoundY;
    
    % Init child
    childA = Gene(0, 0, ubx, lbx, uby, lby);
    childB = Gene(0, 0, ubx, lbx, uby, lby);
    
    savedAX = geneA.geneStr(10 : 13);
    savedAY = geneA.geneStr(23 : 26);
    savedBX = geneB.geneStr(10 : 13);
    savedBY = geneB.geneStr(23 : 26);
    
    newGeneA = append(geneA.geneStr(1 : 9), savedBX, geneA.geneStr(14 : 22), savedBY);
    newGeneB = append(geneB.geneStr(1 : 9), savedAX, geneB.geneStr(14 : 22), savedAY);
    childA = childA.setGene(newGeneA);
    childB = childB.setGene(newGeneB);
end

% function [childA, childB] = crossOver(geneA, geneB)
%     % Get boundary
%     ubx = geneA.upperBoundX;
%     lbx = geneA.lowerBoundX;
%     uby = geneA.upperBoundY;
%     lby = geneA.lowerBoundY;
% 
%     % Init child
%     childA = Gene(0, 0, ubx, lbx, uby, lby);
%     childB = Gene(0, 0, ubx, lbx, uby, lby);
% 
%     % Copy the gene sequence
%     savedGeneA = geneA.geneStr(10: 17);
%     savedGeneB = geneB.geneStr(10: 17);
% 
%     % Gene switch
%     newGeneA = append(geneA.geneStr(1: 9), savedGeneB, geneA.geneStr(18: 26));
%     newGeneB = append(geneB.geneStr(1: 9), savedGeneA, geneB.geneStr(18: 26));
%     childA = childA.setGene(newGeneA);
%     childB = childB.setGene(newGeneB);
% end

