%% calc_vgrams
load boxinfo
for ib=1:length(boxinfo)
   maps=ncread(strcat('../CoreBx/',ncn{boxinfo(ib).region}),'__xarray_dataarray_variable__');
   dmap=diff(maps,1,3);
   dmap(dmap<=-20)=0;
   dmap(isnan(dmap))=0;
   dm = dmap(:,:,boxinfo(ib).dmap);
   nx = size(dm,1)
   ny = size(dm,2)
   xx = [1:nx];
   yy = [1:ny];
   
   xxd = [floor(boxinfo(ib).xp(1)):ceil(boxinfo(ib).xp(2))];
   yyd = [floor(boxinfo(ib).yp(1)):ceil(boxinfo(ib).yp(2))];
   ds = dm(xxd,yyd);
   
   [X,Y] = meshgrid(xxd,yyd);
   X = X(:);
   Y = Y(:);
   D = ds(:);
   n = length(D);
   i = unique(randi(n,[1000,1]));
   x = X(i);
   y = Y(i);
   z = D(i);
   
   figure(1); clf
   pcolorjw(xx,yy,dm')
   hold on
   caxis([-.5 .5])
   boxx = [boxinfo(ib).xp(1),boxinfo(ib).xp(1),boxinfo(ib).xp(2),boxinfo(ib).xp(2),boxinfo(ib).xp(1)];
   boxy = [boxinfo(ib).yp(1),boxinfo(ib).yp(2),boxinfo(ib).yp(2),boxinfo(ib).yp(1),boxinfo(ib).yp(1)];
   plot(boxx,boxy,'-r','linewidth',2)
   scatter(x,y,12,z,'filled'); box on;


   fn = sprintf('region_%d_dmap_%d_map.png',boxinfo(ib).region,boxinfo(ib).dmap)
   print(fn,'-dpng','-r300')

   figure(2); clf
   d = variogram([x y],z,'plotit',false,'nrbins',50);
   a0 = 50 % initial value for range
   c0 = 0.02    % initial value for sill semivariance
   [a,c,n,S] = variogramfit(d.distance,d.val,a0,c0);
   ts = sprintf('Region: %d dmap: %d Range: %.3f sill: %.5f',boxinfo(ib).region,boxinfo(ib).dmap,a,c)
   title(ts)
   fn = sprintf('region_%d_dmap_%d_variogram.png',boxinfo(ib).region,boxinfo(ib).dmap)
   print(fn,'-dpng','-r300')
   
   
   varinfo(ib).a = a;
   varinfo(ib).c = c;
   varinfo(ib).S = S;
end
% %%
% figure(4); clf
% for j=1:7
%    subplot(4,2,j)
%    [a,c,n,S] = variogramfit(d2.distance,d2.val(:,j),a0,c0)
%    ts = sprintf('Theta: %f; Range: %f; sill: %f',rad2deg(d2.theta(j)),a,c);
%    title(ts)
% end



