clearvars; clc;
%Prompt asking for skin
skinnamewear = inputdlg({'Name of skin:', 'Wear:','Average float:'}, 'Prompt', 1, {'SG 553 Bulldozer','Minimal Wear','0.09'});
skinname = skinnamewear{1};
wear = skinnamewear{2};
avgfloat = skinnamewear{3};
skindata = namewear2data(skinname,wear);
%Split skindata to components
[~, remain] = strtok(skindata, char(10));
[~, remain] = strtok(remain(2:end), char(10));
[~, remain] = strtok(remain(2:end), char(10));
[~, remain] = strtok(remain(2:end), char(10));
[marketprize, remain] = strtok(remain(2:end), char(10));
opprize = strtok(remain(2:end), char(10));
%Trade up skins
[skinspostdata,prizes,outcomenumbers] = tradeuplogic(skindata,avgfloat);
disp(['Possible outcomes: ' char(10)]);
disp(skinspostdata);
%Cost check
skinsmarketcost = 10*str2double(marketprize);
skinsopcost = 10*str2double(opprize);
%Profit
