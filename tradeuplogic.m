function [skinspost] = tradeuplogic(skindata)
    %Split skindata to components
    [collection, remain] = strtok(skindata, char(10));
    [rarity, remain] = strtok(remain(2:end), char(10));
    [float_min, remain] = strtok(remain(2:end), char(10));
    [float_max, remain] = strtok(remain(2:end), char(10));
    [marketprize, remain] = strtok(remain(2:end), char(10));
    opprize = strtok(remain(2:end), char(10));
    %Rarities
    cov = cellstr('Covert          ');
    cls = cellstr('Classified      ');
    res = cellstr('Restricted      ');
    mil = cellstr('Mil-Spec        ');
    ind = cellstr('Industrial Grade');
    con = cellstr('Consumer Grade  ');
    rarities = cell(6,1);
    rarities(1:6) = [cov; cls; res; mil; ind; con];
    for i = 1:6
        tf = strcmp(rarity, rarities{i});
        if tf == 1
            break
        end
    end
    tradeuprarity = rarities{i-1};
    
    %Directories
    addpath('./Text_Files');
    filename = [cd '/Text_Files/skintest.txt'];
    %Open file
    fileID = fopen(filename,'r');
    %Scan file to array
    formatSpec = '%s';
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '\n');
    %Close file
    fclose(fileID);
    %Output variable
    skins = [dataArray{1:end}];
    %Match rarity with skin name
    n = 1;
    Delimiter = '';
    for i = 1:length(skins)
        tf = strcmp(skins{i}, Delimiter);
        if tf == 1
            skinend = i;
            individualskin = skins(n:skinend-1);
            rarityname = individualskin{3};
            tf = strcmp(tradeuprarity, rarityname);
            if tf == 1
                break
            end
            n = skinend + 1;
        end
    end
end

