% pick_spots - choose flat regions in difference maps for

% make a list of .nc files to evaluate
ncn = {'region_1.nc','region_2.nc','region_3.nc',...
   'region_4.nc','region_5.nc','region_6.nc',...
   'region_7.nc','region_8.nc','region_9.nc'};

nregions=9;
ndiffmaps=3;

% array counter
ia=0

for ir=1:nregions
   maps=ncread(strcat('../CoreBx/',ncn{ir}),'__xarray_dataarray_variable__');
   dmap=diff(maps,1,3);
   for im=1:ndiffmaps   
      dm = dmap(:,:,im);
      nx = size(dm,1)
      ny = size(dm,2)
      xx = [1:nx];
      yy = [1:ny];
      
      figure(1); clf
      pcolorjw(xx,yy,dm')
      hold on
      caxis([-.5 .5])
      for k=1:2
         [xp,yp]=ginput(2)
         boxx = [xp(1),xp(1),xp(2),xp(2),xp(1)];
         boxy = [yp(1),yp(2),yp(2),yp(1),yp(1)];
         plot(boxx,boxy,'-r','linewidth',2)
      end
      ia = ia+1;
      boxinfo(ia).region = ir;
      boxinfo(ia).dmap = im;
      boxinfo(ia).xp = xp;
      boxinfo(ia).yp = yp;
   end
end
save('boxinfo.mat', 'boxinfo')
%%

xxd = [floor(xp(1)):ceil(xp(2))];
yyd = [floor(yp(1)):ceil(yp(2))];
ds = dm(xxd,yyd);

[X,Y] = meshgrid(xxd,yyd);
X = X(:);
Y = Y(:);
D = ds(:);
n = length(D);
i = unique(randi(n,[500,1]));
x = X(i);
y = Y(i);
z = D(i);

%%
figure(3); clf
a0 = 50 % initial value for range
c0 = 0.02    % initial value for sill semivariance
[a,c,n,S] = variogramfit(d.distance,d.val,a0,c0);
ts = sprintf('Range: %f; sill: %f',a,c)
title(ts)
%%
figure(4); clf
for j=1:7
   subplot(4,2,j)
   [a,c,n,S] = variogramfit(d2.distance,d2.val(:,j),a0,c0)
   ts = sprintf('Theta: %f; Range: %f; sill: %f',rad2deg(d2.theta(j)),a,c);
   title(ts)
end



