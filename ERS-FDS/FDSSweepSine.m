function [ FDS ] = FDSSweepSine( x2punti_m, zita, K, C, bWohler, f0, f1, f2, tb, t )
%FDSSweepSine calcola l'FDS di un sistema SDOF sollecitato con sweep sine
%   FDS = FDSSweepSine(x2punti_m, zita, T, K, C, bWohler, f0, f1, f2, tb, t);
%
%   x2punti_m = ampiezza dello sweep dell'accelerazione imposta dalla tavola vibrante (m/s^2)
%   zita = fattore di smorzamento del sistema
%   K = costante di proporzionalità spostamento-tensioni per un sistema SDOF
%   C = costante di proporzionalità della curva di Basquin
%   bWohler = coefficiente angolare della curva di Wohler
%   f0 = vettore delle possibili frequenze naturali del sistema SDOF (Hz)
%   f1 = frequenza di inizio sweep (Hz)
%   f2 = frequenza di fine sweep (Hz)
%   tb = tempo di durata dello sweep (s)
%   t = vettore del tempo (s)

f = f1+(f2-f1)/tb*t;                % vettore delle frequenze dello sweep
l_f = length(f);
l_f0 = length(f0);

h = zeros(1,l_f);                   % vettore h: usato nel ciclo for per contenere il rapporto f(t)./f0(i-esimo) (NOTA: usando un vettore riga il ciclo for è più rapido rispetto a un vettore colonna... è scritto nell'help)
integranda = zeros(1,l_f);          % vettore utilizzato per contenere la funzione da integrare (pag. 89 Lalanne vol.5 (2009))
integraleTrapz = zeros(1,l_f0);     % vettore che contiene il risultato dell'integrazione per trapeziper ogni elemento di f0
for i = 1:l_f0
    h = (f./f0(i));
    integranda = h./(((1-h.^2).^2+(2*zita*h).^2).^(bWohler/2));
    integraleTrapz(i) = trapz(h,integranda);
end

FDS = K^bWohler/C*(f0.^2*tb*x2punti_m^bWohler)./((4*pi^2*f0.^2).^bWohler*(f2-f1)).*integraleTrapz;

end

