seq = input("Enter a Chromosome string: ", 's');
data = findGene(seq);

if isempty(data)
    fprintf('no gene is found\n');
end

[a, ds] = size(data);
for i = 1 : ds
    fprintf('%s\n', data(i));
end


function validData = findGene(geneSeq)
    startGene = 'ATG';
    endGenes = ['TAA'; 'TAG'; 'TGA'];
    buffer = '000';
    validFlag = false;
    data = '';
    validData = [];
    
    for i = 1 : strlength(geneSeq)
        buffer = updateBuffer(buffer, geneSeq(i));
        if ~validFlag
            if strcmp(buffer, startGene)
                validFlag = true;
                buffer = '000';
            end
        else
            data = [data, geneSeq(i)];
            if checkEnd(buffer, endGenes)
                data = data(1 : strlength(data) - 3);
                validFlag = false;
                if mod(strlength(data), 3) == 0
                    validData = [validData, convertCharsToStrings(data)];
                end
                data = '';
                buffer = '000';
            end
        end
    end
end

function buffer = updateBuffer(buffer, c)
    buffer = [buffer(2), buffer(3), c];
end

function tf = checkEnd(buffer, endGenes)
    tf = false;
    for i = 1 : 3
        if strcmp(buffer, endGenes(i, 1 : 3))
            tf = true;
            break;
        end
    end
end