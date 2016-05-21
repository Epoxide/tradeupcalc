function [skindata] = namewear2data(skinname,wear)
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
    %Match skin name with data
    n = 1;
    Delimiter = '';
    skinsarrayend = skins(end);
    for i = 1:length(skins)
        tf = strcmp(skins{i}, Delimiter);
        if tf == 1
            skinend = i;
            individualskin = skins(n:skinend-1);
            weaponname = individualskin{1};
            skintypename = individualskin{2};
            individualskinname = [weaponname ' ' skintypename];
            tf = strcmp(skinname, individualskinname);
            if tf == 1
               break
            end
            n = skinend + 1;
        end
        tf = strcmp(skins{i}, skinsarrayend(1));
        if tf == 1
            individualskin = skins(n:end);
            weaponname = individualskin{1};
            skintypename = individualskin{2};
            individualskinname = [weaponname ' ' skintypename];
            tf = strcmp(skinname, individualskinname);
            if tf == 1
               break
            end
        end
    end
    %Data
    rarity = individualskin{3};
    collection = individualskin{4};
    float_min = individualskin{5};
    float_max = individualskin{6};
    wears = float2wears(float_min, float_max);
    n = 7;
    for i = 1:5
       if isempty(wears{i}) == 0
           marketprize = individualskin{n};
           opprize = individualskin{n+1};
           n = n + 2;
       end
       tf = strcmp(wear, wears{i});
       if tf == 1
           break
       end
    end
    skindata = [collection char(10) rarity char(10) float_min char(10) float_max char(10) marketprize char(10) opprize];
end

