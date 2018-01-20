function [n] = numberOfBits(x)
    n = 0;
    x = abs(x);
    while x ~= 0
        n = n + 1;
        x = bitshift(x, -1);
    end
%     if x == 0
%         n = 0;
%     elseif x == 1
%         n = 1;
%     else
%         n = ceil(log2(abs(x)));
%     end
end