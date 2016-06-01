function [ ERS ] = ERSGaussianLoadNarrowband( zita, T, f0, PSD, fwelch )
%ERSGaussianLoadNarrowband calcola l'ERS nel caso di sollecitazione
%gaussiana in cui la risposta del sistema è narrow band
%   ERS = ERSGaussianLoadNarrowband( zita, T, f0, PSD, fwelch );
%   
%   zita = fattore di smorzamento del sistema
%   T = durata del segnale (s)
%   f0 = vettore delle possibili frequenze naturali del sistema SDOF (Hz)
%   PSD = PSD della forzante del sistema SDOF (EU^2/Hz)
%   fwelch = vettore delle frequenze della PSD (Hz)

% calcolo l'RMS(z(t)) e RMS(z_punto(t)):
n = length(fwelch);
m = length(f0);
h = zeros(m,n);                 % h = matrice in cui ogni colonna contiene fwelch./f0 per ogni frequenza j-esima di fwelch
                                % dimensioni (m,n)
for j = 1:n
    h(:,j) = fwelch(j)./f0;
end
alfa = 2*sqrt(1-zita^2);
beta = 2*(1-2*zita^2);

I0 = zita/(pi*alfa)*log((h.^2+alfa.*h+1)./(h.^2-alfa.*h+1))+(atan((2.*h+alfa)./(2*zita))+atan((2.*h-alfa)./(2*zita)))/pi;
I1 = 2/(pi*alfa)*(atan((2.*h-alfa)./(2*zita))-atan((2.*h+alfa)./(2*zita)));
I2 = zita/(pi*alfa)*log((h.^2-alfa*h+1)./(h.^2+alfa*h+1))+(atan((2*h+alfa)/(2*zita))+atan((2*h-alfa)/(2*zita)))/pi;
I3 = zita/pi*log((1-h.^2).^2+4*zita^2*h.^2)+beta/(pi*alfa)*(atan((2*h-alfa)/(2*zita))-atan((2*h+alfa)/(2*zita)));

deltaI0 = diff(I0,1,2);         % dimensioni (m,n-1)
deltaI1 = diff(I1,1,2);         % dimensioni (m,n-1)
deltaI2 = diff(I2,1,2);         % dimensioni (m,n-1)
deltaI3 = diff(I3,1,2);         % dimensioni (m,n-1)
deltah = diff(h,1,2);           % dimensioni (m,n-1)

a = zeros(m,n);                 % dimensioni (m,n)
b = a;                          % dimensioni (m,n)

a(:,1) = (h(:,2).*deltaI0(:,1)-deltaI1(:,1))./deltah(:,1);
a(:,n) = (deltaI1(:,n-1)-h(:,n-1).*deltaI0(:,n-1))./deltah(:,n-1);
a(:,2:n-1) = (deltaI1(:,1:n-2)-h(:,1:n-2).*deltaI0(:,1:n-2))./deltah(:,1:n-2) - (deltaI1(:,2:n-1)-h(:,3:n).*deltaI0(:,2:n-1))./(deltah(:,2:n-1));
b(:,1) = (h(:,2).*deltaI2(:,1)-deltaI3(:,1))./(deltah(:,1));
b(:,n) = (deltaI3(:,n-1)-h(:,n-1).*deltaI2(:,n-1))./(deltah(:,n-1));
b(:,2:n-1) = (deltaI3(:,1:n-2)-h(:,1:n-2).*deltaI2(:,1:n-2))./deltah(:,1:n-2) - (deltaI3(:,2:n-1)-h(:,3:n).*deltaI2(:,2:n-1))./(deltah(:,2:n-1));

sommatoria_ajGj = a*PSD';       % sommatoria per il calcolo del rms(z(t))^2 (è un vettore perché ho tante sommatorie quanti sono i valori di f0)
zRmsQuadro = pi./(4*zita*(2*pi)^4*(f0').^3).*sommatoria_ajGj;
zRms = sqrt(zRmsQuadro);        % rms(z(t)) in funzione della frequenza naturale f0 del sistema SDOF

sommatoria_bjGj = b*PSD';
zPuntoRmsQuadro = pi./(4*zita*(2*pi)^2*f0').*sommatoria_bjGj;
zPuntoRms = sqrt(zPuntoRmsQuadro);  % rms(zPunto(t)) in funzione della frequenza naturale f0 del sistema SDOF

n0plus = zPuntoRms./(2*pi*zRms);

ERS = (2*pi*f0').^2.*zRms.*sqrt(2*log(n0plus*T));

end

