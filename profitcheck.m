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
marketpostcut = zeros(outcomenumbers,1);
profitopprice = zeros(outcomenumbers,1);
oppostcut = zeros(outcomenumbers,1);
percentage = num2str(100/outcomenumbers);
marketdispstr = ['You have a ' percentage '% to earn/lose '];
marketpostcutdisp = ['After fees you have a ' percentage '% to earn/lose '];
opdispstr = ['You have a ' percentage '% to earn/lose '];
oppostcutdisp = ['After fees you have a ' percentage '% to earn/lose '];
for i = 1:outcomenumbers
    earnedmarketprice = str2double(prices{n+6});
    profitmarketprice(i) = earnedmarketprice-skinsmarketcost;
    if profitmarketprice(i) <= 0
        marketpostcut(i) = earnedmarketprice*0.95-skinsmarketcost;
    else
        marketpostcut(i) = profitmarketprice(i)*0.95;
    end
    if profitmarketprice(i) <= 0.03 && profitmarketprice(i) > 0
        marketpostcut(i) = 0.01;
    end
    earnedopprice = str2double(prices{n+7});
    profitopprice(i) = earnedopprice-skinsopcost;
    if profitopprice(i) <= 0
        oppostcut(i) = earnedopprice*0.90-skinsopcost;
    else
        oppostcut(i) = profitopprice(i)*0.90;
    end
    marketdispstr = [marketdispstr '€' num2str(profitmarketprice(i)) ' or '];
    marketpostcutdisp = [marketpostcutdisp '€' num2str(marketpostcut(i)) ' or '];
    opdispstr = [opdispstr '€' num2str(profitopprice(i)) ' or '];
    oppostcutdisp = [oppostcutdisp '€' num2str(oppostcut(i)) ' or '];
    if i == outcomenumbers
        marketdispstr = [marketdispstr(1:end-4) ' on the Steam market.' char(10)];
        marketpostcutdisp = [marketpostcutdisp(1:end-4) ' on the Steam market.' char(10)];
        opdispstr = [opdispstr(1:end-4) ' on OPskins.' char(10)];
        oppostcutdisp = [oppostcutdisp(1:end-4) ' on the Steam market.' char(10)];
    end
    n = n + 9;
end

%Display
disp(['Used skin(s): ' skinname]);
disp(['Wear(s): ' wear]);
disp(['Average float: ' avgfloat char(10)]);
disp(['Possible outcomes: ' char(10)]);
disp(skinspostdata);
disp([char(10) 'The trade-up will cost you €' num2str(skinsmarketcost) ' on the Steam market and €' num2str(skinsopcost) ' on OPskins.' char(10)]);
disp(marketdispstr);
disp(marketpostcutdisp);
disp(opdispstr);
disp(oppostcutdisp);
