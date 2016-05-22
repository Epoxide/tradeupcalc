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
[marketprice, remain] = strtok(remain(2:end), char(10));
opprice = strtok(remain(2:end), char(10));
%Trade up skins
[skinspostdata,prices,outcomenumbers] = tradeuplogic(skindata,avgfloat);
%Cost check
skinsmarketcost = 10*str2double(marketprice);
skinsopcost = 10*str2double(opprice);
%Profit
n = 1;
profitmarketprice = zeros(outcomenumbers,1);
profitopprice = zeros(outcomenumbers,1);
for i = 1:outcomenumbers
    earnedmarketprice = str2double(prices{n+6});
    profitmarketprice(i) = earnedmarketprice-skinsmarketcost;
    earnedopprice = str2double(prices{n+7});
    profitopprice(i) = earnedopprice-skinsopcost;
    n = n + 9;
end
percentage = num2str(100/outcomenumbers);

%Display
disp(['Used skin(s): ' skinname ' ' wear]);
disp(['Average float: ' avgfloat char(10)]);
disp(['Possible outcomes: ' char(10)]);
disp(skinspostdata);
disp([char(10) 'The trade-up will cost you €' num2str(skinsmarketcost) ' on the Steam market and €' num2str(skinsopcost) ' on OPskins.' char(10)]);
disp(['You have a ' percentage '% to earn/lose €' num2str(profitmarketprice(1)) ' and a ' percentage '% to earn/lose €' num2str(profitmarketprice(2)) ' on the Steam market.' char(10)]);
disp(['You have a ' percentage '% to earn/lose €' num2str(profitopprice(1)) ' and a ' percentage '% to earn/lose €' num2str(profitopprice(2)) ' on OPskins.' char(10)]);
