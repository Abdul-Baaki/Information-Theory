clear;
clc;

disp('ABDUL-BAAKI YAKUBU');
%{
str = Put in any string of your choice
    %}
str = input("Please input a string of text of your choice: ", "s" );
ascii_values = double(char(str));
binaryCode = '';
for i=1:length(ascii_values)
    binary_value = dec2bin(ascii_values(i));
    padded_binary_value = sprintf('%08s', binary_value);
    binaryCode =[binaryCode num2str(padded_binary_value)]; 
end
binarySequence = binaryCode;
subsequences = {'0' '1'};

% Generate full subsequences from below loop
i=1;
while i<= length(binarySequence)
    intermediateSequence =binarySequence(i);
    while i<length(binarySequence) && any(strcmp(strcat(intermediateSequence, binarySequence(i+1)),subsequences))
        intermediateSequence = strcat(intermediateSequence, binarySequence(i+1));
        i = i+1;
    end
    if i == length(binarySequence)
        sequenceToBeAdded =  strcat(intermediateSequence,'z');
        subsequences = [subsequences sequenceToBeAdded];
    else
        sequenceToBeAdded = strcat(intermediateSequence, binarySequence(i+1));
        subsequences = [subsequences sequenceToBeAdded];
    end
    i=i+2;   
end
disp('#################################################################################################');

% Numerical representation
%Generate the Numerical representations
numericalRepresentations ={};
i = 3;
while i<= length(subsequences)
    extractedSubsequence = subsequences{i};
    lastChar = extractedSubsequence(end);
    if lastChar == 'z'
        extractedSubsequence = extractedSubsequence(1:end-1);    
    end
    lastChar = extractedSubsequence(end);
    restOfChars = extractedSubsequence(1:end-1);
    indexOfLastChar = find(strcmp(lastChar, subsequences));
    indexOfRestOfChars = find(strcmp(restOfChars, subsequences));
    numericalRepresentation =strcat(num2str(indexOfRestOfChars),num2str(indexOfLastChar));
    numericalRepresentations=[numericalRepresentations numericalRepresentation];
    i = i+1;
end
disp('#################################################################################################');
disp('Numerical Representations');
disp(numericalRepresentations);

%Generate Binary encoded blocks
binaryEncodedBlocks = {};
i = 1;
while i<=length(numericalRepresentations)
    extractedNumRep = numericalRepresentations{i};
    lastNum = extractedNumRep(end);
    if lastNum == '1'
        binaryRepForLastNum = 0;
    else
        binaryRepForLastNum = 1;
    end
    restOfNums = str2double(extractedNumRep(1:end-1));
    if isnan(restOfNums)
        binaryBlock = num2str(binaryRepForLastNum);
        binaryEncodedBlocks = [binaryEncodedBlocks binaryBlock];
    else
        binaryRepForRestOfNums = dec2bin(restOfNums);
        binaryBlock = strcat(num2str(binaryRepForRestOfNums), num2str(binaryRepForLastNum));
        binaryEncodedBlocks = [binaryEncodedBlocks binaryBlock];
    end
    i=i+1;
end
maxLen = max(cellfun(@length, binaryEncodedBlocks));
binaryEncodedBlocks = cellfun(@(x) [repmat('0', 1, maxLen - length(x)), x], binaryEncodedBlocks, 'UniformOutput', false);
disp('#################################################################################################');

disp('Binary Encoded Blocks');
disp(binaryEncodedBlocks);
disp('#################################################################################################');

%Decompress message
%Obtain numerical representation
i=1;
numRepDecoded = {};
while i<=length(binaryEncodedBlocks)
    extractedBlock = binaryEncodedBlocks{i};
    lastBit = extractedBlock(end);
    restOfBits = extractedBlock(1:end-1);
    if lastBit == '0'
        lastBitNumRep = 1;
    else
        lastBitNumRep = 2;
    end
    restOfBitsNumRep = bin2dec(restOfBits);
    numRep = strcat(num2str(restOfBitsNumRep),num2str(lastBitNumRep));
    numRepDecoded = [numRepDecoded numRep];
    i=i+1;
end

%Obtain subsequences
subsequences = {'0' '1'};
i = 1;
while i<=length(numRepDecoded)
    
    charsAtRep = numRepDecoded{i};
    lastCharOfSub = charsAtRep(end);
    restOfCharsOfSub = charsAtRep(1:end-1);
    if lastCharOfSub == '1'
        lastBit = 0;
    else
        lastBit = 1;
    end
    if restOfCharsOfSub == '0'
        if lastCharOfSub == '1'
            subsequence = '0';
        else
            subsequence = '1';
        end
        subsequences = [subsequences subsequence];
    else
        index = str2double(restOfCharsOfSub);
        bitsAtIndex = subsequences{index};
        subsequence = strcat(bitsAtIndex, num2str(lastBit));
        subsequences = [subsequences subsequence];
    end
    i = i+1;
end

%Decoded message in human understandable form
originalMessage = strjoin(subsequences(3:end), '');
binary_values = reshape(originalMessage, 8, []).'; % Reshape the binary code into groups of 8 bits
ascii_values = bin2dec(binary_values); % Convert binary to decimal
decodedMessage = char(ascii_values.'); % Convert decimal to characters
disp('Decoded Message');
disp(decodedMessage);