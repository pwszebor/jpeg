function [encoder] = initHuffmanEncoder()
    encoder.luminanceDC.numberOfCodeWords = [0 1 5 1 1 1 1 1 1 0 0 0 0 0 0 0];
    encoder.luminanceDC.codeWords = hex2dec([
        '00'; '01'; '02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '0A'; '0B'
    ])';
    encoder.chrominanceDC.numberOfCodeWords = [0 3 1 1 1 1 1 1 1 1 1 0 0 0 0 0];
    encoder.chrominanceDC.codeWords = hex2dec([
        '00'; '01'; '02'; '03'; '04'; '05'; '06'; '07'; '08'; '09'; '0A'; '0B'
    ])';

    encoder.luminanceAC.numberOfCodeWords = [0 2 1 3 3 2 4 3 5 5 4 4 0 0 1 125];
    encoder.luminanceAC.codeWords = hex2dec([
        '01'; '02';
        
        '03';
        
        '00'; '04'; '11';
        
        '05'; '12'; '21';
        
        '31'; '41';
        
        '06'; '13'; '51'; '61';
        
        '07'; '22'; '71';
        
        '14'; '32'; '81'; '91'; 'A1';
        
        '08'; '23'; '42'; 'B1'; 'C1';
        
        '15'; '52'; 'D1'; 'F0';
        
        '24'; '33'; '62'; '72';
        
        '82';
        
        '09'; '0A'; '16'; '17'; '18'; '19'; '1A'; '25'; '26'; '27'; '28'; '29'; '2A'; '34';
        '35'; '36'; '37'; '38'; '39'; '3A'; '43'; '44'; '45'; '46'; '47'; '48'; '49'; '4A';
        '53'; '54'; '55'; '56'; '57'; '58'; '59'; '5A'; '63'; '64'; '65'; '66'; '67'; '68';
        '69'; '6A'; '73'; '74'; '75'; '76'; '77'; '78'; '79'; '7A'; '83'; '84'; '85'; '86';
        '87'; '88'; '89'; '8A'; '92'; '93'; '94'; '95'; '96'; '97'; '98'; '99'; '9A'; 'A2';
        'A3'; 'A4'; 'A5'; 'A6'; 'A7'; 'A8'; 'A9'; 'AA'; 'B2'; 'B3'; 'B4'; 'B5'; 'B6'; 'B7';
        'B8'; 'B9'; 'BA'; 'C2'; 'C3'; 'C4'; 'C5'; 'C6'; 'C7'; 'C8'; 'C9'; 'CA'; 'D2'; 'D3';
        'D4'; 'D5'; 'D6'; 'D7'; 'D8'; 'D9'; 'DA'; 'E1'; 'E2'; 'E3'; 'E4'; 'E5'; 'E6'; 'E7';
        'E8'; 'E9'; 'EA'; 'F1'; 'F2'; 'F3'; 'F4'; 'F5'; 'F6'; 'F7'; 'F8'; 'F9'; 'FA'
    ])';

    encoder.chrominanceAC.numberOfCodeWords = [0 2 1 2 4 4 3 4 7 5 4 4 0 1 2 119];
    encoder.chrominanceAC.codeWords = hex2dec([
        '00'; '01';
        
        '02';
        
        '03'; '11';
        
        '04'; '05'; '21'; '31';
        
        '06'; '12'; '41'; '51';
        
        '07'; '61'; '71';
        
        '13'; '22'; '32'; '81';
        
        '08'; '14'; '42'; '91'; 'A1'; 'B1'; 'C1';
        
        '09'; '23'; '33'; '52'; 'F0';
        
        '15'; '62'; '72'; 'D1';

        '0A'; '16'; '24'; '34';
        
        'E1';
        
        '25'; 'F1';
    
        '17'; '18'; '19'; '1A'; '26'; '27'; '28'; '29'; '2A'; '35'; '36'; '37'; '38'; '39';
        '3A'; '43'; '44'; '45'; '46'; '47'; '48'; '49'; '4A'; '53'; '54'; '55'; '56'; '57';
        '58'; '59'; '5A'; '63'; '64'; '65'; '66'; '67'; '68'; '69'; '6A'; '73'; '74'; '75';
        '76'; '77'; '78'; '79'; '7A'; '82'; '83'; '84'; '85'; '86'; '87'; '88'; '89'; '8A';
        '92'; '93'; '94'; '95'; '96'; '97'; '98'; '99'; '9A'; 'A2'; 'A3'; 'A4'; 'A5'; 'A6';
        'A7'; 'A8'; 'A9'; 'AA'; 'B2'; 'B3'; 'B4'; 'B5'; 'B6'; 'B7'; 'B8'; 'B9'; 'BA'; 'C2';
        'C3'; 'C4'; 'C5'; 'C6'; 'C7'; 'C8'; 'C9'; 'CA'; 'D2'; 'D3'; 'D4'; 'D5'; 'D6'; 'D7';
        'D8'; 'D9'; 'DA'; 'E2'; 'E3'; 'E4'; 'E5'; 'E6'; 'E7'; 'E8'; 'E9'; 'EA'; 'F2'; 'F3';
        'F4'; 'F5'; 'F6'; 'F7'; 'F8'; 'F9'; 'FA'
    ])';

	encoder.luminanceDC.codesAndSizes = zeros(length(encoder.luminanceDC.codeWords), 2);
	encoder.chrominanceDC.codesAndSizes = zeros(length(encoder.chrominanceDC.codeWords), 2);
	encoder.luminanceAC.codesAndSizes = zeros(length(encoder.luminanceAC.codeWords), 2);
	encoder.luminanceDC.codesAndSizes = zeros(length(encoder.luminanceDC.codeWords), 2);
    
    p = 0;
    for l = 1:16
        for i = 1 : encoder.luminanceDC.numberOfCodeWords(l)
            huffsize(p+1) = l;
            p = p + 1;
        end
    end
    huffsize(p+1) = 0;
    lastp = p;

    code = 0;
    si = huffsize(0+1);
    p = 0;
    while huffsize(p+1) ~= 0
        while huffsize(p+1) == si
            huffcode(p+1) = code;
            p = p + 1;
            code = code + 1;
        end
        code  = bitshift(code, 1);
        si = si + 1;
    end

    for p = 0:lastp-1
        index = encoder.luminanceDC.codeWords(p+1)+1;
        encoder.luminanceDC.codesAndSizes(index, :) = [huffcode(p+1), huffsize(p+1)];
    end
    
    
    
    
    
    
    p = 0;
    for l = 1:16
        for i = 1 : encoder.luminanceAC.numberOfCodeWords(l)
            huffsize(p+1) = l;
            p = p + 1;
        end
    end
    huffsize(p+1) = 0;
    lastp = p;

    code = 0;
    si = huffsize(0+1);
    p = 0;
    while huffsize(p+1) ~= 0
        while huffsize(p+1) == si
            huffcode(p+1) = code;
            p = p + 1;
            code = code + 1;
        end
        code  = bitshift(code, 1);
        si = si + 1;
    end

    for p = 0:lastp-1
        index = encoder.luminanceAC.codeWords(p+1)+1;
        encoder.luminanceAC.codesAndSizes(index, :) = [huffcode(p+1), huffsize(p+1)];
    end
    
    
    
    
    p = 0;
    for l = 1:16
        for i = 1 : encoder.chrominanceDC.numberOfCodeWords(l)
            huffsize(p+1) = l;
            p = p + 1;
        end
    end
    huffsize(p+1) = 0;
    lastp = p;

    code = 0;
    si = huffsize(0+1);
    p = 0;
    while huffsize(p+1) ~= 0
        while huffsize(p+1) == si
            huffcode(p+1) = code;
            p = p + 1;
            code = code + 1;
        end
        code  = bitshift(code, 1);
        si = si + 1;
    end

    for p = 0:lastp-1
        index = encoder.chrominanceDC.codeWords(p+1)+1;
        encoder.chrominanceDC.codesAndSizes(index, :) = [huffcode(p+1), huffsize(p+1)];
    end    
    
    
    
    
    
    p = 0;
    for l = 1:16
        for i = 1 : encoder.chrominanceAC.numberOfCodeWords(l)
            huffsize(p+1) = l;
            p = p + 1;
        end
    end
    huffsize(p+1) = 0;
    lastp = p;

    code = 0;
    si = huffsize(0+1);
    p = 0;
    while huffsize(p+1) ~= 0
        while huffsize(p+1) == si
            huffcode(p+1) = code;
            p = p + 1;
            code = code + 1;
        end
        code  = bitshift(code, 1);
        si = si + 1;
    end

    for p = 0:lastp-1
        index = encoder.chrominanceAC.codeWords(p+1)+1;
        encoder.chrominanceAC.codesAndSizes(index, :) = [huffcode(p+1), huffsize(p+1)];
    end
end