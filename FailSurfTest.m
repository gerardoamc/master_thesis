%Failure Surface plots
clear all
clc
test =1; %Change number to calculate desired surface
if (test==1)
    %G. Mazzei Master Thesis; 11-22 plane
    Xt=40.29;    Xc=43.91;    Yt=31.13;    Yc=57.96;    S=23.35;
    S45p=20.80;    S45n=38.17;    mu1=-0.0052;    mu2=-0.2;    lambda=0;
    x=-70:0.5:50;
    y=-70:0.5:40;
    t12=0;
    [s1,s2]=meshgrid(x,y);
    [F_11,F_1111,F_22,F_2222,F_12,F_1212,F_1122,F_1112,F_2212]=FailSurf.tens(Xt,Xc,Yt,Yc,S,S45p,S45n,mu1,mu2,lambda);
    f=FailSurf.criteria(s1,s2,t12,F_11,F_1111,F_22,F_2222,F_12,F_1212,F_1122,F_1112,F_2212);
    g=contour(s1,s2,f,[1,1],'-k');
    hold on
    box on
    grid on
    axis tight
    daspect([1,1,1]); %data aspect ratio of 1:1
    xlabel('\sigma_{11} [MPa]','fontsize',18)  % x-axis label
    ylabel('\sigma_{22}  [MPa]','fontsize',18)  % y-axis label
    set(gca,'FontSize',16) %Sets the font size for axes
    set(gca,'FontName','CMU Serif') %Sets the font size for axes
    h=contour(s1,s2,f,[1,0.75],'--k');
    i=contour(s1,s2,f,[1,0.5],'-.k');
    j=contour(s1,s2,f,[1,0.25],':k');
    %   clabel(g,'manual','FontName','CMU Serif', 'FontSize', 14)
    clabel([g h i j],'manual','FontName','CMU Serif', 'FontSize', 14)
    %User selected marker location for f values
    Data_summary %load data
    xL = xlim;
    yL = ylim;
    line([0 0], yL,'Color','k');  %x-axis
    line(xL, [0 0],'Color','k');  %y-axis
    plot(x_c(:,1),x_c(:,2),'r.','MarkerSize',20);
    plot(x_t(:,1),x_t(:,2),'r.','MarkerSize',20);
    plot(y_c(:,1),y_c(:,2),'r.','MarkerSize',20);
    plot(y_t(:,1),y_t(:,2),'r.','MarkerSize',20);
elseif (test==2)
    %G. Mazzei Master Thesis; 11-12 plane
    Xt=40.29;    Xc=43.91;    Yt=31.13;    Yc=57.96;    S=23.35;
    S45p=20.80;    S45n=38.17;    mu1112=-0.0052;    mu2212=-0.2;
    lambda=-0.51;
    x=-50:0.5:50;
    y=0:0.5:30;
    s2=0;
    [s1,t12]=meshgrid(x,y);
    [F_11,F_1111,F_22,F_2222,F_12,F_1212,F_1122,F_1112,F_2212]=FailSurf.tens(Xt,Xc,Yt,Yc,S,S45p,S45n,mu1112,mu2212,lambda);
    f=FailSurf.criteria(s1,s2,t12,F_11,F_1111,F_22,F_2222,F_12,F_1212,F_1122,F_1112,F_2212);
    g=contour(s1,t12,f,[1,1],'-k');
    hold on
    box on
    grid on
    axis tight
    daspect([1,1,1]); %data aspect ratio of 1:1
    xlabel('\sigma_{11} [MPa]','fontsize',18)  % x-axis label
    ylabel('\tau_{12}  [MPa]','fontsize',18)  % y-axis label
    set(gca,'FontSize',16) %Sets the font size for axes
    set(gca,'FontName','CMU Serif') %Sets the font size for axes
    h=contour(s1,t12,f,[1,0.75],'--k');
    i=contour(s1,t12,f,[1,0.5],'-.k');
    j=contour(s1,t12,f,[1,0.25],':k');
    clabel([g h i j],'manual','FontName','CMU Serif', 'FontSize', 14)
    %User selected marker location for f values
    Data_summary %load data
    xL = xlim;
    yL = ylim;
    line([0 0], yL,'Color','k');  %x-axis
    line(xL, [0 0],'Color','k');  %y-axis
    xslope = [10 -10];
    yslope = [23.2980 23.4020];
    line(xslope,yslope,'Color',[0.4 0 0],'LineStyle','--','LineWidth',2)
    plot(x_c(:,1),x_c(:,3),'r.','MarkerSize',20);
    plot(x_t(:,1),x_t(:,3),'r.','MarkerSize',20);
    plot(s_0(:,1),s_0(:,3),'r.','MarkerSize',20);
    plot(s_0c(:,1),s_0c(:,3),'r.','MarkerSize',20);
    plot(s_0t(:,1),s_0t(:,3),'r.','MarkerSize',20);
    
elseif (test==3)
    %G. Mazzei Master Thesis; 22-12 plane
    Xt=40.29;    Xc=43.91;    Yt=31.13;    Yc=57.96;    S=23.35;
    S45p=20.80;    S45n=38.17;    mu1112=-0.0052;    mu2212=-0.2;
    lambda=0;
    x=-70:0.5:40;
    y=0:0.5:30;
    s1=0;
    [s2,t12]=meshgrid(x,y);
    [F_11,F_1111,F_22,F_2222,F_12,F_1212,F_1122,F_1112,F_2212]=FailSurf.tens(Xt,Xc,Yt,Yc,S,S45p,S45n,mu1112,mu2212,lambda);
    f=FailSurf.criteria(s1,s2,t12,F_11,F_1111,F_22,F_2222,F_12,F_1212,F_1122,F_1112,F_2212);
    g=contour(s2,t12,f,[1,1],'-k');
    hold on
    box on
    grid on
    axis tight
    daspect([1,1,1]); %data aspect ratio of 1:1
    xlabel('\sigma_{22} [MPa]','fontsize',18)  % x-axis label
    ylabel('\tau_{12}  [MPa]','fontsize',18)  % y-axis label
    set(gca,'FontSize',16) %Sets the font size for axes
    set(gca,'FontName','CMU Serif') %Sets the font size for axes
    h=contour(s2,t12,f,[1,0.75],'--k');
    i=contour(s2,t12,f,[1,0.5],'-.k');
    j=contour(s2,t12,f,[1,0.25],':k');
    clabel([g h i j],'manual','FontName','CMU Serif', 'FontSize', 14)
    %User selected marker location for f values
    Data_summary %load data
    xL = xlim;
    yL = ylim;
    line([0 0], yL,'Color','k');  %x-axis
    line(xL, [0 0],'Color','k');  %y-axis
    xslope = [10 -10];
    yslope = [21.41 25.4100];
    line(xslope,yslope,'Color',[0.4 0 0],'LineStyle','--','LineWidth',2)
    plot(y_c(:,2),y_c(:,3),'r.','MarkerSize',20);
    plot(y_t(:,2),y_t(:,3),'r.','MarkerSize',20);
    plot(s_90(:,2),s_90(:,3),'r.','MarkerSize',20);
    plot(s_90c(:,2),s_90c(:,3),'r.','MarkerSize',20);
    plot(s_90t(:,2),s_90t(:,3),'r.','MarkerSize',20);
    
elseif (test==4)
    %G. Mazzei Master Thesis; Full surface
    Xt=40.29;    Xc=43.91;    Yt=31.13;    Yc=57.96;    S=23.35;
    S45p=20.80;    S45n=38.17;    mu1112=-0.0052;    mu2212=-0.2;
    lambda=0;
    x=-80:0.5:80;
    y=-80:0.5:80;
    z=0:0.5:80;
    [s1,s2,t12]=meshgrid(x,y,z);
    [F_11,F_1111,F_22,F_2222,F_12,F_1212,F_1122,F_1112,F_2212]=FailSurf.tens(Xt,Xc,Yt,Yc,S,S45p,S45n,mu1112,mu2212,lambda);
    f=FailSurf.criteria(s1,s2,t12,F_11,F_1111,F_22,F_2222,F_12,F_1212,F_1122,F_1112,F_2212);
    g=FailSurf.graph(s1,s2,t12,f);
    hold on
    box on
    grid on
    axis tight
    daspect([1,1,1]); %data aspect ratio of 1:1
end