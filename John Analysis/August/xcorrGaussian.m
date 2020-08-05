%% Fit a Gausssian to the paw vectors

% From Mikhail:
% 1) fitting on the 5 step episode
v1 = paws(maxpkx{1,1}(k,1) : maxpkx{1,1}(k+5,1) ,1);
v2 = paws(maxpkx{1,1}(k,1) : maxpkx{1,1}(k+5,1) ,2);

[m1,s1] = normfit(v1);
y1 = normpdf(v1,m1,s1);

[m2,s2] = normfit(v2);
y2 = normpdf(v2,m2,s2);

% figure(2)
% plot(v1,y1,'.');
% hold on;
% plot(v2,y2,'.');

% 2) calculate the correlation
[c, lags] = xcorr(y1, y2);
[~,i] = max(c);
t = i-length(v1);

% 3) fitting the distribution
[m3,s3] = normfit(c);
y3 = normpdf(c,m3,s3);

plot(c,y3,'.');

% plot(lags,c)

%%


v1 = paws(maxpkx{1,1}(k,1) : maxpkx{1,1}(k+5,1) ,1);
v2 = paws(maxpkx{1,1}(k,1) : maxpkx{1,1}(k+5,1) ,2);

[c, lags] = xcorr(v1, v2);

cnew = interp(c,100);
lags_interp = interp(lags,100);

[~,i] = max(cnew);
t = lags_interp(i);















