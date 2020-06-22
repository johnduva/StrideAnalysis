count = 0;
for an = 1: length(zygosity)
    if strcmp(zygosity(an),'negative')
        count = count + 1;
    end
end
disp(count)