function [matrix] = chromaQuantizationMatrix(quality)
	chromaMat = [
        17 18 24 47 99 99 99 99;
        18 21 26 66 99 99 99 99;
        24 26 56 99 99 99 99 99;
        47 66 99 99 99 99 99 99;
        99 99 99 99 99 99 99 99; 
        99 99 99 99 99 99 99 99; 
        99 99 99 99 99 99 99 99;
        99 99 99 99 99 99 99 99
    ];

    if quality <= 50
        S = 5000 / quality;
    else
        S = 200 - 2*quality;
    end
    
    matrix = zeros(size(chromaMat));
    for row = 1 : size(matrix, 1)
        for column = 1 : size(matrix, 2)
            matrix(row, column) = max(1, uint8(floor((chromaMat(row, column) * S + 50)/100)));
        end
    end
end