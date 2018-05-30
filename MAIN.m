%% LEO BOOK CHAPTER PLOTS
%
%  Stanford GPS Lab
%
%  Plots for LEO Book Chapter
%
%  Written by:         Tyler Reid
%
%% WORKSPACE SETUP

clc
clear all
close all

colors = lines(10);
lw = 3; % line width
figFont = 22; % figure font

mu = 3.986004418e14;
R_e = 6378000;

h = [200:100:50000] * 1000;
R_SV = R_e + h;

% altitudes of operational systems
aGPS = 20350;
aGAL = 23200;
aGLO = 19100;
aBei = 21150;
aTransit = 1200;
aOneWeb = 1200; 
aIridium = 780;
aGSO = 35786;
aQZSS = (1+0.075)*(35786+R_e/1000)-R_e/1000;

line_types = {'-','--', '-.','-','--', '-.'};
line_colors = gray(4);

%% SPREADING LOSS

lw = 4;
el = [5, 30, 90] * pi/180; 

figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(gcf,'defaultAxesColorOrder',[left_color; right_color]);

for i = 1:length(el)
    
    slant_range = -R_e * sin(el(i)) + sqrt( R_e^2 * (sin(el(i))^2 - 1) + R_SV.^2 );
    spreading_loss = 10 * log10( slant_range.^-2 / 4 / pi );
    
    yyaxis left          % plot against left y-axis
    semilogx(h / 1000, spreading_loss, line_types{i},'color', line_colors(i,:), 'LineWidth', lw)
    ylabel('Spreading Loss [dB]')
    xlabel('Altitude [km]')
    hold on
    
%     yyaxis right         % plot against right y-axis
%     loglog(h / 1000, slant_range / 1000, 'LineWidth', lw);
%     ylabel('Slant Range [km]')

end
grid on

lw = 2;

% figure out the transformation for the axis label.
min_slant_range = sqrt(1 / (10^(-115 / 10) * 4 * pi)) / 1000 ;
max_slant_range = sqrt(1 / (10^(-170 / 10) * 4 * pi)) / 1000 ;
step_slant_range = logspace(log10(min_slant_range), log10(max_slant_range),12) ;
step_slant_range = round(fliplr(step_slant_range)/100) * 100 ;

yyaxis right
yticks(-170:5:-115)
ylim([-170, -115])
yticklabels({ step_slant_range })
ylabel('Slant Range [km]')

yyaxis left
yticks(-170:5:-115)

% plot satellites
plot(aGPS*[1,1],[-1e3,1e5],'-.','color',[1,1,1]*0.7,'LineWidth',lw)
hold on
plot(aOneWeb*[1,1],[-1e3,1e5],'-.','color',[1,1,1]*0.7,'LineWidth',lw)
hold on
plot(aIridium*[1,1],[-1e3,1e5],'-.','color',[1,1,1]*0.7,'LineWidth',lw)
hold on
plot(aGSO*[1,1],[-1e3,1e5],'-.','color',[1,1,1]*0.7,'LineWidth',lw)
hold on

text(aIridium, -155, 'Iridium', 'Rotation', 90,...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
text(aOneWeb, -155, 'OneWeb', 'Rotation', 90,...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
text(aGPS, -140, 'GPS', 'Rotation', 90,...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
text(aGSO, -140, 'GSO', 'Rotation', 90,...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')

legend('el = 5^o', 'el = 30^o', 'el = 90^o',...
    'location', 'south')
legend('boxoff')

xlim([300, 50000])
ylim([-170, -115])

xticks([500, 1000, 2000, 5000, 10000, 20000, 40000])
set(gca,'XTickLabelRotation',-45)

exportfig(gcf,'spreading_loss.tiff','height',8,'width',10,'fontsize',22,'LineWidth',10,'resolution',300);
exportfig(gcf,'spreading_loss.eps','height',8,'width',10,'fontsize',22,'LineWidth',10,'resolution',300);

%% FOOTPRINT

lw = 4;
el = [5, 10, 15] * pi/180; 

figure;

for i = 1:length(el)
    Area = 2 * pi * R_e^2 * (1 - sin(el(i) + asin(R_e./R_SV * cos(el(i))) ));
    radius_footprint = sqrt(Area/pi);
    radius_footprint = R_e * acos(1 - Area / R_e^2 / 2 / pi);
    semilogx(h / 1000, radius_footprint / 1000, line_types{i},'color', line_colors(i,:), 'LineWidth', lw)
    hold on
end
grid on
xlabel('Altitude [km]')
ylabel('Satellite Footprint Radius [km]')
legend('el = 5^o', 'el = 10^o', 'el = 15^o',...
    'location', 'south')
legend('boxoff')

lw = 2;

% plot satellites
semilogx(aGPS*[1,1],[1e-13,1e5],'-.','color',[1,1,1]*0.7,'LineWidth',lw)
hold on
semilogx(aOneWeb*[1,1],[1e-13,1e5],'-.','color',[1,1,1]*0.7,'LineWidth',lw)
hold on
semilogx(aIridium*[1,1],[1e-13,1e5],'-.','color',[1,1,1]*0.7,'LineWidth',lw)
hold on
semilogx(aGSO*[1,1],[1e-13,1e5],'-.','color',[1,1,1]*0.7,'LineWidth',lw)
hold on

text(aIridium, 5000, 'Iridium', 'Rotation', 90,...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
text(aOneWeb, 5000, 'OneWeb', 'Rotation', 90,...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
text(aGPS, 5000, 'GPS', 'Rotation', 90,...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
text(aGSO, 5000, 'GSO', 'Rotation', 90,...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')

xlim([300, 50000])
ylim([0, 10000])

xticks([500, 1000, 2000, 5000, 10000, 20000, 40000])
set(gca,'XTickLabelRotation',-45)

exportfig(gcf,'footprint.tiff','height',8,'width',10,'fontsize',22,'LineWidth',10,'resolution',300);
exportfig(gcf,'footprint.eps','height',8,'width',10,'fontsize',22,'LineWidth',10,'resolution',300);

%% MEAN MOTION / PERIOD

n = sqrt(mu./R_SV.^3);
T = 2 * pi ./ n;

lw = 4;

figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(gcf,'defaultAxesColorOrder',[left_color; right_color]);
yyaxis left 
loglog(h / 1000, T / 3600, 'linewidth',4);
hold on
% semilogy(h / 1000, n * 180 / pi);
xlabel('Altitude [km]')
ylabel('Orbital Period [hours]')

% yyaxis right
% semilogy(h / 1000, T / 3600);
% ylabel('Orbital Period [hours]')
grid on

lw = 2;
% plot satellites
loglog(aGPS*[1,1],[1e-13,50],'-.','color',[1,1,1]*0.7,'LineWidth',lw)
hold on
loglog(aOneWeb*[1,1],[1e-13,50],'-.','color',[1,1,1]*0.7,'LineWidth',lw)
hold on
loglog(aIridium*[1,1],[1e-13,50],'-.','color',[1,1,1]*0.7,'LineWidth',lw)
hold on
loglog(aGSO*[1,1],[1e-13,50],'-.','color',[1,1,1]*0.7,'LineWidth',lw)
hold on

text(aIridium, 6, 'Iridium', 'Rotation', 90,...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
text(aOneWeb, 6, 'OneWeb', 'Rotation', 90,...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
text(aGPS, 6, 'GPS', 'Rotation', 90,...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
text(aGSO, 6, 'GSO', 'Rotation', 90,...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')
yticks([1, 2, 3, 6, 12, 24])

xlim([300, 50000])
ylim([1, 30])

yyaxis right
loglog(10000,10000)
yticks(log([1, 2, 3, 6, 12, 24]))

rat(360./[1, 2, 3, 6, 12, 24]/3600)

yticklabels({ '1/10','1/20','1/30','1/60','1/120','1/240' })
ylabel('Mean Motion [deg/s]')

xlim([300, 50000])
ylim(log([1, 30]))

xticks([500, 1000, 2000, 5000, 10000, 20000, 40000])
set(gca,'XTickLabelRotation',-45)

exportfig(gcf,'period.tiff','height',8,'width',10,'fontsize',22,'LineWidth',10,'resolution',300);
exportfig(gcf,'period.eps','height',8,'width',10,'fontsize',22,'LineWidth',10,'resolution',300);
