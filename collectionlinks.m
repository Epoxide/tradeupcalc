clearvars; clc;
%Directories
addpath('./Text_Files');
%Save html file
collectionname = inputdlg({'Name of collection:'}, 'Prompt', 1, {'The+Chop+Shop+Collection'});
collectionname = char(collectionname);
folderexist = exist(['../MATLAB/Text_Files/' collectionname]);
if folderexist == 0
    mkdir(['../MATLAB/Text_Files/' collectionname]);
end
filename = [cd '/Text_Files/' collectionname '/' collectionname]; %Change
outputfile = [cd '/Text_Files/' collectionname '/' collectionname '.txt']; %Change
URL = ['https://csgostash.com/collection/' collectionname]; %Change
outfilename = websave(filename,URL);
%Open file
fileID = fopen(outfilename,'r');
%Scan file to array
formatSpec = '%s';
dataArray = textscan(fileID, formatSpec);
%Close file
fclose(fileID);
%Output variable
skins = [dataArray{1:end}];
%Filter out skin link
k = strfind(skins,'csgostash.com/skin/');
columnarray = [];
for i = 1:length(k)
    if isempty(k{i}) == 0
        columnarray = [columnarray; i];
    end
end
celllength = length(columnarray)/3;
linkcell = cell(celllength,1);
j = 1;
for i = 1:3:length(columnarray)
   row = columnarray(i);
   linkcell{j} = skins{row};
   j = j + 1;
end
strlinks = char(linkcell);
strlinkssize = size(strlinks);
strlinklength = strlinkssize(1);
linkfiltered = cell(strlinklength,1);
fileID = fopen(outputfile, 'wt');
for i = 1:strlinklength
    strlinksrow = strlinks(i,:);
    k = strfind(strlinksrow, '"><');
    strlinkfilt = strlinksrow(7:k-1);
    fprintf(fileID, '%s\n%s\n%s', strlinkfilt);
end
fclose(fileID);
