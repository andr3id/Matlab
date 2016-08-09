% APPUNTI PER IL REVERSING DELL'IMMAGINE DEL PROVINO
% ==================================================================

% carico l'immagine del provino in bianco e nero
provino = imread('provino_BW.png');

% clicco su alcuni punti dell'intaglio di cui voglio ricavare il raggio di
% raccordo usando ginput, così acquisisco le coordinate di quei punti
imagesc(provino), axis equal, colormap('gray'), coord = ginput;

% plotto il contorno acquisito con ginput per vedere se è venuto bene
imagesc(provino), axis equal, colormap('gray'), hold on, plot(coord(:,1), coord(:,2), 'r', 'LineWidth',2), hold off

% coordinate del centro e raggio della circonferenza che meglio approssima
% l'intaglio usando la function circfit (calcola la circonferenza usando i
% minimi quadrati)
[xc,yc,R] = circfit(coord(:,1), coord(:,2));

% plot della circonferenza approssimante l'intaglio
theta = 0:pi/100:2*pi;
xCircle = xc+R*cos(theta);
yCircle = yc+R*sin(theta);
imagesc(provino), axis equal, colormap('gray'), hold on, plot(xCircle,yCircle,'r'), hold off

% NOTA: a questo punto le coordinate del centro della circonferenza e il
% suo raggio sono espresse in pixel. Occorre convertirle in mm misurando
% il rapporto pixel/mm