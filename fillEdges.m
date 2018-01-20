function [filled] = fillEdges(matrix, blockSize)
    % resizes matrix to have size that is an integer multiple of blockSize
    % fills the remaining elements with edge values
    
    width = size(matrix, 2);
    height = size(matrix, 1);
    
    missingWidth = blockSize - mod(width, blockSize);
    if missingWidth == blockSize
        missingWidth = 0;
    end
    missingHeight = blockSize - mod(height, blockSize);
    if missingHeight == blockSize
        missingHeight = 0;
    end
    
    filled = matrix;
    
    if missingWidth ~= 0
        lastColumn = filled(:, width);
        filled(:, width + 1 : width + missingWidth) = repmat(lastColumn, 1, missingWidth);
    end
    
    if missingHeight ~= 0
        lastRow = filled(height, :);
        filled(height + 1 : height + missingHeight, :) = repmat(lastRow, missingHeight, 1);
    end
    
    filled(height + missingHeight, width + missingWidth) = filled(height, width);
end