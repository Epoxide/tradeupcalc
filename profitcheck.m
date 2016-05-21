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
%Cost check
skinsmarketcost = 10*str2double(marketprize);
skinsopcost = 10*str2double(opprize);
%Profit
n = 1;
profitmarketprize = zeros(outcomenumbers,1);
profitopprize = zeros(outcomenumbers,1);
for i = 1:outcomenumbers
    earnedmarketprize = str2double(prizes{n+6});
    profitmarketprize(i) = earnedmarketprize-skinsmarketcost;
    earnedopprize = str2double(prizes{n+7});
    profitopprize(i) = earnedopprize-skinsopcost;
    n = n + 9;
end
percentage = num2str(100/outcomenumbers);

%Display
disp(['Used skin(s): ' skinname ' ' wear]);
disp(['Average float: ' avgfloat char(10)]);
disp(['Possible outcomes: ' char(10)]);
disp(skinspostdata);
disp([char(10) 'The trade-up will cost you $' num2str(skinsmarketcost) ' on the Steam market and $' num2str(skinsopcost) ' on OPskins.' char(10)]);
disp(['You have a ' percentage '% to earn/lose $' num2str(profitmarketprize(1)) ' and a ' percentage '% to earn/lose $' num2str(profitmarketprize(2)) ' on the Steam market.' char(10)]);
disp(['You have a ' percentage '% to earn/lose $' num2str(profitopprize(1)) ' and a ' percentage '% to earn/lose $' num2str(profitopprize(2)) ' on OPskins.' char(10)]);
