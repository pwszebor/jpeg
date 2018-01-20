function [dcCoeff] = huffmanEncodeAndSave(file, encoder, block, previousDC, type)
    if isequal(type, 'luma')
        dcCodesAndSizes = encoder.luminanceDC.codesAndSizes;
        acCodesAndSizes = encoder.luminanceAC.codesAndSizes;
    else
        dcCodesAndSizes = encoder.chrominanceDC.codesAndSizes;
        acCodesAndSizes = encoder.chrominanceAC.codesAndSizes;
    end
    
    dcCoeff = block(1);
    
    dcCoeffDiff = dcCoeff - previousDC;
    bits = numberOfBits(dcCoeffDiff);
    if dcCoeffDiff < 0
        dcCoeffDiff = dcCoeffDiff - 1;
    end

    write(file, dcCodesAndSizes(bits+1, 1), dcCodesAndSizes(bits+1, 2));
    if bits ~= 0
        write(file, dcCoeffDiff, bits);
    end

    
    zeroRunLength = 0;

    for k = 2:64 
        acCoeff = block(k);
        if acCoeff == 0
            zeroRunLength = zeroRunLength + 1;
        else
            while zeroRunLength > 15 
                write(file, acCodesAndSizes(hex2dec('F0')+1, 1), acCodesAndSizes(hex2dec('F0')+1, 2));
                zeroRunLength = zeroRunLength - 16;
            end
            bits = numberOfBits(acCoeff);
            if acCoeff < 0
                acCoeff = acCoeff - 1;
            end
            
            codeWord = bitshift(zeroRunLength, 4) + bits;
            write(file, acCodesAndSizes(codeWord + 1, 1), acCodesAndSizes(codeWord + 1, 2));
            write(file, acCoeff, bits);

            zeroRunLength = 0;
        end
    end

    if zeroRunLength > 0
        % EOB - end of block
        write(file, acCodesAndSizes(1, 1), acCodesAndSizes(1, 2));
    end
end

function [] = write(file, code, size)
    global bitsWritten;
    global dataWritten;

    if code < 0
        code = (2^32)+code;
    end
    data = code;
    bits = bitsWritten;

    temp = bitshift(1, size) - 1;

    data = bitand(data, temp);
    bits = bits + size;
    data = bitshift(data, 24-bits);
    data = bitor(data, dataWritten);
    
    while bits >= 8
        c = bitand(bitshift(data, -16), hex2dec('FF'));
        fwrite(file, c);
        
        if c == hex2dec('FF')
            fwrite(file, 0);
        end
        data = bitand(bitshift(1, 24) - 1, bitshift(data, 8));
        bits = bits - 8;
    end
    dataWritten = data;
    bitsWritten = bits;
end
