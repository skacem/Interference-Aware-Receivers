function printIEEE(filename,FontName)
% PRINTIEEE
%   printIEEE(filename)


if nargin<2
    FontName = 'Times New Roman';
end

% axes and ticks
HAxis = gca;
set(HAxis,'Linewidth',0.5)
set(HAxis,'Xcolor',[0 0 0]);
set(HAxis,'Ycolor',[0 0 0]);
set(HAxis,'Zcolor',[0 0 0]);
set(HAxis,'FontName',FontName);
set(HAxis,'FontSize',8);

% the labels
xLabelHandle = get(HAxis,'XLabel');
yLabelHandle = get(HAxis,'YLabel');
zLabelHandle = get(HAxis,'ZLabel');
set(xLabelHandle,'FontName',FontName);
set(xLabelHandle,'FontSize',8);
set(xLabelHandle,'Color',[0 0 0]);
set(yLabelHandle,'FontName',FontName);
set(yLabelHandle,'FontSize',8);
set(yLabelHandle,'Color',[0 0 0]);
set(zLabelHandle,'FontName',FontName);
set(zLabelHandle,'FontSize',8);
set(zLabelHandle,'Color',[0 0 0]);

% the title
titleHandle = get(HAxis,'Title');
set(titleHandle,'FontName',FontName);
set(titleHandle,'FontSize',10);
set(titleHandle,'Color',[0 0 0]);

grid on;

v = get(gca,'View');
if (v(1) == 0) && (v(2) == 90)
    printFigure(filename,75);
else
    printFigureSurf(filename,70);
end;

function printFigure(fileName,width)
% width = width / 25.4 * 1.2892;
width = width / 25.4 * 1.5;
heigth = width * 0.75;
% heigth = width * 1.5;
set(gca,'plotboxaspectratio',[1 0.75 1]);
set(gcf,'PaperUnits','inch');
set(gcf,'PaperSize',[width, heigth]);
set(gcf,'PaperPosition',[0,0,width, heigth]);
set(gcf,'Renderer','painters');
print('-depsc2', fileName);


function printFigureSurf(fileName,width)
width = width / 25.4 * 1.2892;
heigth = width * 0.75;
set(gcf,'PaperUnits','inch');
set(gcf,'PaperSize',[width, heigth]);
set(gcf,'PaperPosition',[0,0,width, heigth]);
set(gcf,'Renderer','painters');
print('-depsc2', fileName);
