function [] = flash(file)
    global bitsWritten;
    global dataWritten;
    
    data = dataWritten;
    bits = bitsWritten;
    while bits >= 8 
        c = bitand(bitshift(data, -16), hex2dec('FF'));
        fwrite(file, c);
        
        if c == hex2dec('FF')
            fwrite(file, 0);
        end
        data = bitshift(data, 8);
        bits = bits - 8;
    end
    if bits > 0 
        c = bitand(bitshift(data, -16), hex2dec('FF'));
        fwrite(file, c);
    end
    fwrite(file, []);
end