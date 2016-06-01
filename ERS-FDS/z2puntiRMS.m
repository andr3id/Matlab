function [ z2puntiRMS ] = z2puntiRMS( zita, f0, PSD, fwelch )
%z2puntiRMS calcola l'RMS dell'accelerazione z2punti(t) di un sistema SDOF
%in funzione delle possibili frequenze naturali f0 , quando è sollecitato
%con un'accelerazione random 
%   z2puntiRMS = z2puntiRMS(zita,f0,PSD,fwelch);
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

I0 = zita/(pi*alfa)*log((h.^2+alfa.*h+1)./(h.^2-alfa.*h+1))+(atan((2.*h+alfa)./(2*zita))+atan((2.*h-alfa)./(2*zita)))/pi;
I1 = 2/(pi*alfa)*(atan((2.*h-alfa)./(2*zita))-atan((2.*h+alfa)./(2*zita)));
I2 = zita/(pi*alfa)*log((h.^2-alfa*h+1)./(h.^2+alfa*h+1))+(atan((2*h+alfa)/(2*zita))+atan((2*h-alfa)/(2*zita)))/pi;
I3 = zita/pi*log((1-h.^2).^2+4*zita^2*h.^2)+beta/(pi*alfa)*(atan((2*h-alfa)/(2*zita))-atan((2*h+alfa)/(2*zita)));
I4 = 4*zita/pi*h+beta*I2-I0;
I5 = 2*zita/pi*h.^2+beta*I3-I1;

deltaI4 = diff(I4,1,2);         % dimensioni (m,n-1)
deltaI5 = diff(I5,1,2);         % dimensioni (m,n-1)
deltah = diff(h,1,2);           % dimensioni (m,n-1)

c = zeros(m,n);                 % dimensioni (m,n)
c(:,1) = (h(:,2).*deltaI4(:,1)-deltaI5(:,1))./deltah(:,1);
c(:,n) = (deltaI5(:,n-1)-h(:,n-1).*deltaI4(:,n-1))./deltah(:,n-1);
c(:,2:n-1) = (deltaI5(:,1:n-2)-h(:,1:n-2).*deltaI4(:,1:n-2))./deltah(:,1:n-2) - (deltaI5(:,2:n-1)-h(:,3:n).*deltaI4(:,2:n-1))./deltah(:,2:n-1);

sommatoria_cjGj = c*PSD';       % sommatoria per il calcolo del rms(z2punti(t)) (è un vettore perché ho tante sommatorie quanti sono i valori di f0)
z2puntiRMS = sqrt(pi/(4*zita)*f0'.*sommatoria_cjGj);

end