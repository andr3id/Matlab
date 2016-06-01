function [ zpuntoRMS ] = zpuntoRMS( zita, f0, PSD, fwelch )
%zpuntoRMS calcola l'RMS della velocità zpunto(t) di un sistema SDOF in
%funzione delle possibili frequenze naturali f0 , quando è sollecitato con
%un'accelerazione random 
%   zpuntoRMS = zpuntoRMS(zita,f0,PSD,fwelch);
%
%   zita = fattore di smorzamento del sistema
%   f0 = vettore delle possibili frequenze naturali del sistema SDOF (Hz)
%   PSD = PSD dell'eccitazione x2punti(t) del sistema SDOF (EU^2/Hz)
%   fwelch = vettore delle frequenze della PSD (Hz)

n = length(fwelch);
m = length(f0);
h = zeros(m,n);                 % h = matrice in cui ogni colonna contiene fwelch./f0 per ogni frequenza j-esima di fwelch
                                % dimensioni (m,n)
for j = 1:n
    h(:,j) = fwelch(j)./f0;
end

alfa = 2*sqrt(1-zita^2);
beta = 2*(1-2*zita^2);

I2 = zita/(pi*alfa)*log((h.^2-alfa*h+1)./(h.^2+alfa*h+1))+(atan((2*h+alfa)/(2*zita))+atan((2*h-alfa)/(2*zita)))/pi;
I3 = zita/pi*log((1-h.^2).^2+4*zita^2*h.^2)+beta/(pi*alfa)*(atan((2*h-alfa)/(2*zita))-atan((2*h+alfa)/(2*zita)));

deltaI2 = diff(I2,1,2);         % dimensioni (m,n-1)
deltaI3 = diff(I3,1,2);         % dimensioni (m,n-1)
deltah = diff(h,1,2);           % dimensioni (m,n-1)

b = zeros(m,n);                 % dimensioni (m,n)
b(:,1) = (h(:,2).*deltaI2(:,1)-deltaI3(:,1))./deltah(:,1);
b(:,n) = (deltaI3(:,n-1)-h(:,n-1).*deltaI2(:,n-1))./deltah(:,n-1);
b(:,2:n-1) = (deltaI3(:,1:n-2)-h(:,1:n-2).*deltaI2(:,1:n-2))./deltah(:,1:n-2) - (deltaI3(:,2:n-1)-h(:,3:n).*deltaI2(:,2:n-1))./deltah(:,2:n-1);

sommatoria_bjGj = b*PSD';       % sommatoria per il calcolo del rms(zpunto(t)) (è un vettore perché ho tante sommatorie quanti sono i valori di f0)
zpuntoRMS = sqrt(pi./(4*zita*(2*pi)^2*f0').*sommatoria_bjGj);

end