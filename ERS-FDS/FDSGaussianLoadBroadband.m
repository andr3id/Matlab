function [ FDS ] = FDSGaussianLoadBroadband( zita, T, K, C, bWohler, f0, PSD, fwelch )
%FDSGaussianLoadBroadband calcola l'FDS nel caso di sollecitazione
%gaussiana in cui la risposta del sistema è a banda larga
%   FDS = FDSGaussianLoadBroadband( zita, T, K, C, bWohler, f0, PSD, fwelch );
%   
%   zita = fattore di smorzamento del sistema
%   T = durata del segnale (s)
%   K = costante di proporzionalità spostamento-tensioni per un sistema SDOF
%   C = costante di proporzionalità della curva di Basquin
%   bWohler = coefficiente angolare della curva di Wohler
%   f0 = vettore delle possibili frequenze naturali del sistema SDOF (Hz)
%   PSD = PSD del segnale di cui si vuole calcolare l'ERS (EU^2/Hz)
%   fwelch = vettore delle frequenze della PSD (Hz)

% partendo dalla PSD dell'eccitazione x2punti(t) ricavo i valori RMS della
% risposta del sistema SDOF (RMS di posizione, velocità e accelerazione) in
% funzione delle possibili freq. nat. del sistema
z_RMS = zRMS(zita,f0,PSD,fwelch);
z_puntoRMS = zpuntoRMS(zita,f0,PSD,fwelch);
z_2puntiRMS = z2puntiRMS(zita,f0,PSD,fwelch);
n_0plus = n0plus(z_RMS,z_puntoRMS);
n_pplus = npplus(z_puntoRMS,z_2puntiRMS);

r = n_0plus./n_pplus;                                 % irregularity factor (funzione di f0)

dzp = 0.0001;
zp = 0:dzp:0.1;                                  % possibili valori dello spostamento zp (m) [VALORI A CASO...]
FDS = zeros(size(f0));
for i = 1:length(FDS)
    integranda = zp.^bWohler.*(sqrt((1-r(i)^2)./(2*pi)).*exp(-zp.^2./(2*(1-r(i)^2)*z_RMS(i)^2))+...
                 r(i)*zp./(2*z_RMS(i)).*exp(-zp.^2./(2*z_RMS(i)^2)).*...
                 (1+erf(r(i)*zp./(z_RMS(i)*sqrt(2*(1-r(i)^2))))));
    FDS(i) = K^bWohler/C*n_pplus(i)*T/z_RMS(i)*dzp*trapz(integranda);
end
