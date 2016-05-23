function [skinspostdata,prices,outcomenumbers] = tradeuplogic(skindata,avgfloat)
    %Split skindata to components
    [collection, remain] = strtok(skindata, char(10));
    [rarity, remain] = strtok(remain(2:end), char(10));
    [~, remain] = strtok(remain(2:end), char(10));
    [~, ~] = strtok(remain(2:end), char(10));
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
    filename = [cd '/Text_Files/skintest2.txt'];
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
    tradeupskins = [];
    skinsarrayend = skins(end);
    for i = 2:length(skins)
        tf = strcmp(skins{i}, Delimiter);
        if tf == 1
            skinend = i;
            individualskin = skins(n:skinend-1);
            rarityname = individualskin{3};
            tf = strcmp(tradeuprarity, rarityname);
            if tf == 1
                tradeupskins = [tradeupskins; individualskin; char(10)];
            end
            n = skinend + 1;
        end
        tf = strcmp(skins{i}, skinsarrayend{1});
        if tf == 1
            individualskin = skins(n:end);
            rarityname = individualskin{3};
            tf = strcmp(tradeuprarity, rarityname);
            if tf == 1
                tradeupskins = [tradeupskins; individualskin; char(10)];
            end
        end
    end
    tradeupskins = tradeupskins(1:end-1);
    %Match collection with skin name
    n = 1;
    tradeupskinsc = [];
    tradeupskinsarrayend = tradeupskins(end);
    for i = 1:length(tradeupskins)
       tf = strcmp(tradeupskins{i}, char(10));
       if tf == 1
           skinend = i;
           individualskin = tradeupskins(n:skinend-1);
           collectionname = individualskin{4};
           tf = strcmp(collection, collectionname);
           if tf == 1
              tradeupskinsc = [tradeupskinsc; individualskin; char(10)];
           end
           n = skinend + 1;
       end
       if i == length(tradeupskins)
            individualskin = tradeupskins(n:end);
            collectionname = individualskin{4};
            tf = strcmp(collection, collectionname);
            if tf == 1
                tradeupskinsc = [tradeupskinsc; individualskin; char(10)];
            end
        end
    end
    tradeupskinsc = tradeupskinsc(1:end-1);
    %Float outcome
    floats = [];
    tradeupskinscarrayend = tradeupskinsc(end);
    n = 1;
    for i = 1:length(tradeupskinsc)
       tf = strcmp(tradeupskinsc{i}, char(10));
       if tf == 1
          skinend = i;
          individualskin = tradeupskinsc(n:skinend-1);
          float_min = num2str(individualskin{5});
          float_max = num2str(individualskin{6});
          floats = [floats; float_min; float_max];
          n = skinend + 1;
       end
       if i == length(tradeupskinsc)
          individualskin = tradeupskinsc(n:end);
          float_min = num2str(individualskin{5});
          float_max = num2str(individualskin{6});
          floats = [floats; float_min; float_max];
       end
    end
    floats = cellstr(floats);
    outcomefloats = [];
    avgfloat = str2double(avgfloat);
    for i = 1:2:length(floats)-1
        float_min = str2double(floats{i});
        float_max = str2double(floats{i+1});
        outcomefloat = (float_max-float_min) * avgfloat + float_min;
        outcomefloats = [outcomefloats; outcomefloat];
    end
    %Format output
    wears = [];
    for i = 1:length(outcomefloats)
        wear = float2wears(num2str(outcomefloats(i)), num2str(outcomefloats(i)));
        wears = [wears; wear; char(10)];
    end
    wears = wears(1:end-1);
    tradeupwears = [];
    n = 0;
    for i = 1:length(wears)
        tf = strcmp(wears{i}, char(10));
        if tf == 1
            wears{i} = [];
        end
        if isempty(wears{i}) == 0
            n = n + 1;
            tradeupwears = [tradeupwears wears{i} char(10)];
        end
    end
    tradeupwears = tradeupwears(1:end-1);
    celltradeupwears = cell(n,1);
    n = 1;
    m = 1;
    for i = 1:length(tradeupwears)
        tf = strcmp(tradeupwears(i), char(10));
        if tf == 1
            celltradeupwears{m} = tradeupwears(n:i-1);
            n = i + 1;
            m = m + 1;
        end
        if i == length(tradeupwears)
           celltradeupwears{m} = tradeupwears(n:end); 
        end
    end
    tradeupwearssize = size(celltradeupwears);
    outcomenumbers = tradeupwearssize(1);
    prices = cell(outcomenumbers*9-1,1);
    celloutcomefloats = cellstr(num2str(outcomefloats,'%.4f'));
    n = 1;
    o = 1;
    k = 1;
    for i = 1:length(tradeupskinsc)
        tf = strcmp(tradeupskinsc{i}, char(10));
        if tf == 1
            skinend = i;
            individualskin = tradeupskinsc(n:skinend-1);
            m = 7;
            l = 1;
            for j = o:o+4
                if isempty(wears{j}) == 0
                    marketprice = individualskin{m};
                    opprice = individualskin{m+1};
                    prices{k} = individualskin{1};
                    prices{k+1} = individualskin{2};
                    prices{k+2} = individualskin{3};
                    prices{k+3} = individualskin{4};
                    prices{k+4} = celloutcomefloats{l};
                    prices{k+5} = celltradeupwears{l};
                    prices{k+6} = marketprice;
                    prices{k+7} = opprice;
                    prices{k+8} = char(10);
                    k = k + 9;
                    l = l + 1;
                end
            end
            n = skinend + 1;
            o = o + 5;
        end
        if i == length(tradeupskinsc)
            individualskin = tradeupskinsc(n:end);
            m = 7;
            for j = o:o+4
                if isempty(wears{j}) == 0
                    marketprice = individualskin{m};
                    opprice = individualskin{m+1};
                    prices{end-7} = individualskin{1};
                    prices{end-6} = individualskin{2};
                    prices{end-5} = individualskin{3};
                    prices{end-4} = individualskin{4};
                    prices{end-3} = celloutcomefloats{end};
                    prices{end-2} = celltradeupwears{end};
                    prices{end-1} = marketprice;
                    prices{end} = opprice;
                    m = m + 2;
                end
            end
        end
    end
    skinspostdata = char(prices);
end
