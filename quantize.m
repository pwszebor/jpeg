function [quantized] = quantize(input, quantizationMatrix)
    assert(isequal(size(input), size(quantizationMatrix)), 'Input matrix and quantization matrix must be the same size')
    aanScale = [1.0 1.387039845 1.306562965 1.175875602 1.0 0.785694958 0.541196100 0.275899379];
    input = double(input);
%     quantized = round(input ./ quantizationMatrix);
    quantized = zeros(size(input));
    for row = 1 : size(input, 1)
        for column = 1 : size(input, 2)
%             quantized(row, column) = round(input(row, column) / quantizationMatrix(row, column));
            quantized(row, column) = round(input(row, column) / (quantizationMatrix(row, column) * aanScale(row) * aanScale(column) * 8));
        end
    end
end