function [ zRMS ] = zRMS( zita, f0, PSD, fwelch )
%zRMS calcola l'RMS della risposta z(t) in funzione delle possibili frequenze
%naturali f0 di un sistema SDOF, quando è sollecitato con una accelerazione
%random 
%   zRMS = zRMS(zita,f0,PSD,fwelch);
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

I0 = zita/(pi*alfa)*log((h.^2+alfa.*h+1)./(h.^2-alfa.*h+1))+(atan((2.*h+alfa)./(2*zita))+atan((2.*h-alfa)./(2*zita)))/pi;
I1 = 2/(pi*alfa)*(atan((2.*h-alfa)./(2*zita))-atan((2.*h+alfa)./(2*zita)));

deltaI0 = diff(I0,1,2);         % dimensioni (m,n-1)
deltaI1 = diff(I1,1,2);         % dimensioni (m,n-1)
deltah = diff(h,1,2);           % dimensioni (m,n-1)

a = zeros(m,n);                 % dimensioni (m,n)
a(:,1) = (h(:,2).*deltaI0(:,1)-deltaI1(:,1))./deltah(:,1);
a(:,n) = (deltaI1(:,n-1)-h(:,n-1).*deltaI0(:,n-1))./deltah(:,n-1);
a(:,2:n-1) = (deltaI1(:,1:n-2)-h(:,1:n-2).*deltaI0(:,1:n-2))./deltah(:,1:n-2) - (deltaI1(:,2:n-1)-h(:,3:n).*deltaI0(:,2:n-1))./deltah(:,2:n-1);

sommatoria_ajGj = a*PSD';       % sommatoria per il calcolo del rms(z(t)) (è un vettore perché ho tante sommatorie quanti sono i valori di f0)
zRMS = sqrt(pi./(4*zita*(2*pi)^4*(f0').^3).*sommatoria_ajGj);

end