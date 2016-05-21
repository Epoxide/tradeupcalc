function [skinspostdata] = tradeuplogic(skindata,avgfloat)
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
    tradeupskins = [];
    skinsarrayend = skins(end);
    for i = 1:length(skins)
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
       tf = strcmp(tradeupskins{i}, tradeupskinsarrayend{1});
       if tf == 1
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
       tf = strcmp(tradeupskinsc{i}, tradeupskinscarrayend{1});
       if tf == 1
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
    for i = 1:length(wears)
        tf = strcmp(wears{i}, char(10));
        if tf == 1
            wears{i} = [];
        end
        if isempty(wears{i}) == 0
            tradeupwears = [tradeupwears; wears{i}];
        end
    end
    celltradeupwears = cellstr(tradeupwears);
    tradeupwearssize = size(tradeupwears);
    outcomenumbers = tradeupwearssize(1);
    prizes = cell(outcomenumbers*8,1);
    celloutcomefloats = cellstr(num2str(outcomefloats));
    n = 1;
    for i = 1:length(tradeupskinsc)
        tf = strcmp(tradeupskinsc{i}, char(10));
        if tf == 1
            skinend = i;
            individualskin = tradeupskinsc(n:skinend-1);
            m = 7;
            k = 1;
            l = 1;
            for j = 1:5
                if isempty(wears{j}) == 0
                    marketprize = individualskin{m};
                    opprize = individualskin{m+1};
                    prizes{k} = individualskin{n};
                    prizes{k+1} = individualskin{n+1};
                    prizes{k+2} = individualskin{n+2};
                    prizes{k+3} = individualskin{n+3};
                    prizes{k+4} = celloutcomefloats(l);
                    prizes{k+5} = celltradeupwears{l};
                    prizes{k+6} = marketprize;
                    prizes{k+7} = opprize;
                    m = m + 2;
                    k = k + 8;
                    l = l + 1;
                end
            end
            n = skinend + 1;
        end
        tf = strcmp(tradeupskinsc{i}, tradeupskinscarrayend{1});
        if tf == 1
            individualskin = tradeupskinsc(n:end);
            m = 7;
            for j = 1:5
                if isempty(wears{j}) == 0
                    marketprize = individualskin{m};
                    opprize = individualskin{m+1};
                    prizes{end-7} = individualskin{1};
                    prizes{end-6} = individualskin{2};
                    prizes{end-5} = individualskin{3};
                    prizes{end-4} = individualskin{4};
                    prizes{end-3} = celloutcomefloats{end};
                    prizes{end-2} = celltradeupwears{end};
                    prizes{end-1} = marketprize;
                    prizes{end} = opprize;
                    m = m + 2;
                end
            end
        end
    end
end
