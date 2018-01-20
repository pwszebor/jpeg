function [] = writeJpegHeader(file, compressionInfo)
    fwrite(file, hex2dec(['FF'; 'D8'])); % SOI - start of image
    
    % JFIF segment
    fwrite(file, hex2dec(['FF'; 'E0'])); % JFIF segment marker
    fwrite(file, hex2dec(['00'; '10'])); % JFIF segment size
    fwrite(file, ['J'; 'F'; 'I'; 'F']);
    fwrite(file, hex2dec('00'));
    fwrite(file, hex2dec('01')); % major revision number
    fwrite(file, hex2dec('00')); % minor revision number
    fwrite(file, hex2dec('00')); % no units for x/y densities
    fwrite(file, hex2dec(['00'; '01']));
    fwrite(file, hex2dec(['00'; '01']));
    fwrite(file, hex2dec(['00'; '00']));
    
    % DQT segment
    fwrite(file, hex2dec(['FF'; 'DB'])); % DQT segment marker
    fwrite(file, hex2dec(['00'; '84'])); % DQT segment size
    
    fwrite(file, hex2dec('00')); % luminance QT
    fwrite(file, zigzag(compressionInfo.lumaQMatrix));
    
    fwrite(file, hex2dec('01')); % chrominance QT
    fwrite(file, zigzag(compressionInfo.chromaQMatrix));
    
    % SOF - start of frame segment
    fwrite(file, hex2dec(['FF'; 'C0'])); % SOF marker
    fwrite(file, hex2dec(['00'; '11']));
    fwrite(file, hex2dec('08')); % bits per sample
    h = compressionInfo.imageSize(1);
    w = compressionInfo.imageSize(2);
    fwrite(file, [bitand(bitshift(h, -8), hex2dec('FF')), bitand(h, hex2dec('FF'))]); % height of image (2 bytes)
    fwrite(file, [bitand(bitshift(w, -8), hex2dec('FF')), bitand(w, hex2dec('FF'))]); % width of image (2 bytes)
    fwrite(file, hex2dec('03')); % number of components (Y, Cb, Cr)
    fwrite(file, hex2dec(['01'; '11'; '00'])); % Y (id, sampling factors, QT number)
    fwrite(file, hex2dec(['02'; '11'; '01'])); % Cb
    fwrite(file, hex2dec(['03'; '11'; '01'])); % Cr
    
    % DHT segment
    fwrite(file, hex2dec(['FF'; 'C4'])); % DHT segment marker
    fwrite(file, hex2dec(['01'; 'A2'])); % DHT segment size
    
    fwrite(file, hex2dec('00')); % DC luminance table
    fwrite(file, compressionInfo.huffmanEncoder.luminanceDC.numberOfCodeWords);
    fwrite(file, compressionInfo.huffmanEncoder.luminanceDC.codeWords);
    
    fwrite(file, hex2dec('10')); % AC luminance table
    fwrite(file, compressionInfo.huffmanEncoder.luminanceAC.numberOfCodeWords);
    fwrite(file, compressionInfo.huffmanEncoder.luminanceAC.codeWords);
    
    fwrite(file, hex2dec('01')); % DC chrominance table
    fwrite(file, compressionInfo.huffmanEncoder.chrominanceDC.numberOfCodeWords);
    fwrite(file, compressionInfo.huffmanEncoder.chrominanceDC.codeWords);
    
    fwrite(file, hex2dec('11')); % AC chrominance table
    fwrite(file, compressionInfo.huffmanEncoder.chrominanceAC.numberOfCodeWords);
    fwrite(file, compressionInfo.huffmanEncoder.chrominanceAC.codeWords);
    
    % SOS - start of scan segment
    fwrite(file, hex2dec(['FF'; 'DA'])); % SOS marker
    fwrite(file, hex2dec(['00'; '0C']));
    fwrite(file, hex2dec('03'));
    fwrite(file, hex2dec(['01'; '00'])); % Y (id, HT number)
    fwrite(file, hex2dec(['02'; '11'])); % Cb
    fwrite(file, hex2dec(['03'; '11'])); % Cr
    fwrite(file, hex2dec(['00'; '3F'; '00']));
end