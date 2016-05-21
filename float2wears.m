function [wears] = float2wears(float_min, float_max)
    fn = cellstr('Factory New   ');
    mw = cellstr('Minimal Wear  ');
    ft = cellstr('Field-Tested  ');
    ww = cellstr('Well-Worn     ');
    bs = cellstr('Battle-Scarred');
    wears = cell(5,1);
    float_min = str2double(float_min);
    float_max = str2double(float_max);
    if float_max < 0.07
        wears(1) = fn;
    elseif float_max < 0.15
        wears(1:2) = [fn; mw];
    elseif float_max < 0.38
        wears(1:3) = [fn; mw; ft];
    elseif float_max < 0.45
        wears(1:4) = [fn; mw; ft; ww];
    else
        wears(1:5) = [fn; mw; ft; ww; bs];
    end
    if float_min >= 0.45
        for i = 1:4
            wears{i} = [];
        end
    elseif float_min >= 0.38
        for i = 1:3
            wears{i} = [];
        end
    elseif float_min >= 0.15
        for i = 1:2
            wears{i} = [];
        end
    elseif float_min >= 0.07
        wears{1} = [];
    end
end
