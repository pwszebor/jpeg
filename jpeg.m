function [compressionInfo] = jpeg(image, quality, outputFile)
    assert(quality > 0 && quality <= 100, 'Quality parameter must be between 1 and 100.')
    
    [file, msg] = fopen(outputFile, 'w');
    assert(file ~= -1, msg)

    global bitsWritten;
    global dataWritten;
    bitsWritten = 0;
    dataWritten = 0;
    
    % conversion from RGB color space to YCbCr color space
    img = rgb2ycbcr(image);
    Y = img(:, :, 1);
    Cb = img(:, :, 2);
    Cr = img(:, :, 3);

    % dividing into blocks
    blockSize = 8;
    
    Y = fillEdges(Y, 8);
    Cb = fillEdges(Cb, 8);
    Cr = fillEdges(Cr, 8);
    
    horizontalBlockCount = size(Y, 2) / blockSize;
    verticalBlockCount = size(Y, 1) / blockSize;
    
    blocksY = mat2cell(Y, repmat(blockSize, [1, verticalBlockCount]), repmat(blockSize, [1, horizontalBlockCount]));
    blocksCb = mat2cell(Cb, repmat(blockSize, [1, verticalBlockCount]), repmat(blockSize, [1, horizontalBlockCount]));
    blocksCr = mat2cell(Cr, repmat(blockSize, [1, verticalBlockCount]), repmat(blockSize, [1, horizontalBlockCount]));
    
    lumaQMatrix = lumaQuantizationMatrix(quality);
    chromaQMatrix = chromaQuantizationMatrix(quality);
    
    huffmanEncoder = initHuffmanEncoder();

    compressionInfo.imageSize = size(Y);
    compressionInfo.quality = quality;
    compressionInfo.lumaQMatrix = lumaQMatrix;
    compressionInfo.chromaQMatrix = chromaQMatrix;
    compressionInfo.huffmanEncoder = huffmanEncoder;
    
    writeJpegHeader(file, compressionInfo);
    
    previousDC = [0, 0, 0];
    for row = 1 : verticalBlockCount
        for column = 1 : horizontalBlockCount
            blocksY{row, column} = cosineTransform(blocksY{row, column});
            blocksY{row, column} = quantize(blocksY{row, column}, lumaQMatrix);
            blocksY{row, column} = zigzag(blocksY{row, column});
            previousDC(1) = huffmanEncodeAndSave(file, huffmanEncoder, blocksY{row, column}, previousDC(1), 'luma');

            blocksCb{row, column} = cosineTransform(blocksCb{row, column});
            blocksCb{row, column} = quantize(blocksCb{row, column}, chromaQMatrix);
            blocksCb{row, column} = zigzag(blocksCb{row, column});
            previousDC(2) = huffmanEncodeAndSave(file, huffmanEncoder, blocksCb{row, column}, previousDC(2), 'chroma');

            blocksCr{row, column} = cosineTransform(blocksCr{row, column});
            blocksCr{row, column} = quantize(blocksCr{row, column}, chromaQMatrix);
            blocksCr{row, column} = zigzag(blocksCr{row, column});
            previousDC(3) = huffmanEncodeAndSave(file, huffmanEncoder, blocksCr{row, column}, previousDC(3), 'chroma');
        end
    end
    
    flash(file);
    
    fwrite(file, hex2dec(['FF'; 'D9'])); % EOI - end of image
    fclose(file);
end
