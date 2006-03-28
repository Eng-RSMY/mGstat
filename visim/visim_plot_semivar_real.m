% visim_plot_smeivar_real : plot experimental semivariogram from VISIM run
%
% CALL : 
%    visim_plot_semivar_real(V)
%
%    [g,hc,sv,hc2]=visim_plot_semivar_real(V,ang,tolerance,cutoff,width)
%
% TMH/2006
%
function [g,hc,sv,hc2]=visim_plot_semivar_real(V,ang,tolerance,cutoff,width)

if isstruct(V)~=1
  V=read_visim(V);
end

if nargin<2
  ang=[0 90];
end
if nargin<3
  tolerance=15;
end
if nargin<4
  cutoff=sqrt((max(V.x)-V.x(1)).^2+ (max(V.y)-V.y(1)).^2 + (max(V.z)-V.z(1)).^2);
  cutoff=str2num(sprintf('%12.1g',cutoff));
end
if nargin<5
  width=cutoff/15;
  width=str2num(sprintf('%12.1g',width));
end
col{1}=[0 0 0];
col{2}=[1 0 0];
col{3}=[0 0 1];
lstyle{1}=('-');
lstyle{2}=('--');
lstyle{3}=(':');

for ia=1:length(ang)
  a(ia)=V.Va.ang1+ang(ia);
    % [g{ia},hc{ia}]=visim_semivar(V,1:10,a(ia),tolerance);
    [g{ia},hc{ia}]=visim_semivar(V,1:V.nsim,a(ia),tolerance,cutoff,width);
end

  
[v1,v2]=visim_format_variogram(V);
vtxt{1}=v1;
vtxt{2}=v2;

v1=deformat_variogram(v1);
v2=deformat_variogram(v2);
hc2=linspace(0,max(hc{1}),40);
[sv{1}]=semivar_synth(v1,hc2,0);  
[sv{2}]=semivar_synth(v2,hc2,0);  


i=0;
for ia=1:length(ang)
  i=i+1;
  subplot(2,2,i)
  pall=plot(hc{ia},g{ia},'-','color',[1 1 1].*.7,'linewidth',.1);
  pall=pall(1);
  hold on
  pmean=plot(hc{ia},mean(g{ia}')','-','color',col{1},'linestyle',lstyle{1});
  p(i)=pall(1);
  
  ptrue=plot(hc2,sv{i},'k-','linewidth',3,'linestyle',lstyle{1});
  
  pout{ia}=[pall,pmean,ptrue];
  try
    if ia>0
      [hLeg,hObj]=legend([pall,pmean,ptrue],'All sim','Mean of all sim',vtxt{ia});
      set(hLeg,'box','off')
      set(hLeg,'Location','Best');
    end
  catch
    keyboard
  end


  xlabel('Distance')
  ylabel('Semivariance, \gamma')
  
  axis([0 max(hc2) 0 V.Va.cc*2.0])
  
  hold off
  
end



[f1,f2,f3]=fileparts(V.parfile);
print_mul(sprintf('%s_semivar_real',f2))

