function [  ] = plotGaussianOverHistogram( y, mu, sigma )
%plotGaussianOverHistogram disegna la gaussiana sovrapposta all'istogramma
%   [  ] = plotGaussianOverHistogram( y, mu, sigma )
%
%   y = segnale di cui plottare l'istogramma della distribuzione gaussiana
%   mu = media della gaussiana del segnale
%   sigma = deviazione standard del segnale

h = histogram(y,'Normalization','pdf');                                 % plot dell'istogramma del segnale e creazione dell'oggetto h che ne contiene le proprietà

xGaussiana = linspace(h.BinLimits(1),h.BinLimits(2),100);               % vettore delle ascisse della campana gaussiana (100 elementi)
Gaussiana =  exp(-(xGaussiana-mu).^2./(2*sigma^2))/(sigma*sqrt(2*pi));  % campana gaussiana

hold on
plot(xGaussiana, Gaussiana, 'r', 'LineWidth', 1.5)
hold off

end

