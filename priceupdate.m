clearvars; clc;
%Directories
addpath('./Text_Files');
pricefile = [cd '/Text_Files/skintest2.txt'];
numberofcollections = 2;
collections = cell(numberofcollections,1);
collections{1} = 'The+Assault+Collection';
collections{2} = 'The+Chop+Shop+Collection';
writestr = [];
for i = 1:numberofcollections
    if i > 1
        writestr = [writestr char(10)];
    end
    collectionname = collections{i};
    strcollection = strrep(collectionname, '+', ' ');
    filename = [cd '/Text_Files/' collectionname '/' collectionname '.txt'];
    %Open file
    fileID = fopen(filename,'r');
    %Scan file to array
    formatSpec = '%s';
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '\n');
    %Close file
    fclose(fileID);
    %Output variable
    links = [dataArray{1:end}];
    for p = 1:length(links)
        linkrow = links{p};
        k = strfind(linkrow,'/');
        skinname = linkrow(k(end)+1:end);
        outputfile = [cd '/Text_Files/' collectionname '/'  skinname];
        URL = linkrow;
        outfilename = websave(outputfile,URL);
        skin = fileread(outfilename);
        k = strfind(skin, '<div class="well result-box nomargin">');
        l = strfind(skin, '<img class="img-responsive center-block"');
        rarity = skin(k:l);
        k = strfind(rarity, '<p class="nomargin">');
        rarity = rarity(k+20:end);
        k = strfind(rarity, '</p>');
        rarity = rarity(1:k-1);
        k = strfind(rarity, ' ');
        rarity = rarity(1:k-1);
        industrial = 'Industrial';
        consumer = 'Consumer';
        tf1 = strcmp(rarity, industrial);
        tf2 = strcmp(rarity, consumer);
        if tf1 == 1 || tf2 == 1
            rarity = [rarity ' Grade'];
        end
        k = strfind(skin, 'data-wearMin=');
        float_min = skin(k+14:k+17);
        k = strfind(skin, 'data-wearMax=');
        float_max = skin(k+14:k+17);
        k = strfind(skin, '<tbody>');
        l = strfind(skin, '</tbody>');
        prices = skin(k:l);
        k = strfind(prices, 'data-sort=');
        n = 2;
        forlength = (length(k)/6);
        marketpricecell = cell(forlength,1);
        oppricecell = cell(forlength,1);
        for j = 1:forlength
            pos1 = k(n);
            pos2 = k(n+1);
            marketprice = prices(pos1:pos2);
            l = strfind(marketprice, '&euro;');
            marketpricecell{j} = marketprice(l-7:l-1);
            pos1 = k(n+3);
            pos2 = k(n+4);
            opprice = prices(pos1:pos2);
            l = strfind(opprice, '&euro;');
            oppricecell{j} = opprice(l-7:l-1);
            n = n + 6;
        end
        k = strfind(skin, '<title>');
        l = strfind(skin, '</title>');
        skinname = skin(k+7:l-15);
        k = strfind(skinname, '|');
        weaponname = skinname(1:k-2);
        familyname = skinname(k+2:end);
        writestr = [writestr char(10) weaponname char(10) familyname char(10) rarity char(10) strcollection char(10) float_min char(10) float_max];
        for j = 1:forlength
            if isempty(marketpricecell{j}) == 1
                marketpricecell{j} = 'No price available';
            end
            if isempty(oppricecell{j}) == 1
                oppricecell{j} = 'No price available';
            end
            writestr = [writestr char(10) marketpricecell{j} char(10) oppricecell{j}];
        end
        writestr = [writestr char(10)];
    end
    writestr = writestr(1:end-1);
    writestr = strrep(writestr, '--', '00');
    writestr = strrep(writestr, ',', '.');
    writestr = strrep(writestr, 'w">', '');
    writestr = strrep(writestr, '">', '');
    writestr = strrep(writestr, '>', '');
    writesize = size(writestr);
    writelength = writesize(1);
    fileID = fopen(pricefile, 'wt');
    for j = 1:writelength
        writerow = writestr(j,:);
        fprintf(fileID, '%s\n%s\n%s', writerow);
    end
    fclose(fileID);
end
