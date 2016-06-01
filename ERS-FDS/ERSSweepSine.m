function [ ERS ] = ERSSweepSine( zita, f0, f1, f2, x2punti_m )
%ERSSweepSine calcola l'ERS di un sistema SDOF sollecitato con sweep sine
%   ERS = ERSSweepSine(zita, f0, f1, f2, x2punti_m);
%
%   zita = fattore di smorzamento del sistema
%   f0 = vettore delle possibili frequenze naturali del sistema SDOF (Hz)
%   f1 = frequenza di inizio sweep (Hz)
%   f2 = frequenza di fine sweep (Hz)
%   x2punti_m = ampiezza dell'accelerazione imposta dalla tavola vibrante (m/s^2)

ERS = zeros(size(f0));
ind_f1 = findclosest(f0,f1);        % indice in f0 corrispondente alla freq. f1
ind_f2 = findclosest(f0,f2);        % indice in f0 corrispondente alla freq. f2

ERS(1:ind_f1) = x2punti_m./sqrt((1-(f1./f0(1:ind_f1)).^2).^2+(2*zita*f1./f0(1:ind_f1)).^2);           % tratto di ERS per f0 < f1
ERS(ind_f1+1:ind_f2-1) = x2punti_m/(2*zita);                                                          % tratto di ERS per f1 < f0 < f2
ERS(ind_f2:end) = x2punti_m./sqrt((1-(f2./f0(ind_f2:end)).^2).^2+(2*zita*f2./f0(ind_f2:end)).^2);     % tratto di ERS per f0 > f2

end

