function [ PSD, f ] = PSDWelch( y, fs, Nw, overlapPercent )
%PSDWelch è una function che stima la PSD di un segnale usando il metodo di
%Welch. La PSD stimata è già riscalata RMS
%
%Utilizzo:
%   [ pxx,f ] = PSDWelch( y,fs,Nw,overlapPercent );
%   pxx = vettore dell'ampiezza della PSD stimata (EU^2/Hz)
%   f = vettore delle frequenze (Hz)
%   y = segnale
%   fs = frequenza di campionamento (Hz)
%   Nw = numero di punti della finestra temporale
%   overlapPercent = percentuale di sovrapposizione delle finestre


N = length(y);                              % n° di punti del segnale
Window = hann(Nw)';                         % finestra di Hanning (il vettore va trasposto così ho un vettore riga)
Noverlap = fix(overlapPercent/100*Nw);      % n° di punti sovrapposti per ogni finestra
R = Nw-Noverlap;                            % n° di punti non sovrapposti per ogni finestra
K = fix((N-Noverlap)/R);                    % n° di finestre possibili nel segnale
Aw = Nw/sum(Window);                        % fattore di correzione dell'ampiezza
Be = fs*sum(Window.^2)/((sum(Window))^2);   % fattore di correzione della potenza

PSDMatrix = zeros(K,Nw);                    % prealloco la matrice che conterrà il quadrato del valore assoluto della fft di ogni spezzone finestrato
spezzone = zeros(1,Nw);                     % prealloco un vettore in cui di volta in volta verrà caricato uno spezzone di segnale
index = 1:Nw;                               % vettore degli indici di uno spezzone di segnale (il primo spezzone contiene tutti i valori del segnale dall'indice 1 all'indice Nw)
for i=1:K
    spezzone = y(index).*Window;            % carico nella variabile spezzone il primo spezzone di segnale e lo finestro
    PSDMatrix(i,:) = abs(fft(spezzone)).^2; % riempo la riga i-esima di PSDMatrix con il quadrato del valore assoluto della fft dello spezzone considerato
    index = index+R;                        % aggiorno il vettore index che ora deve contenere gli indici del secondo spezzone di segnale
end
PSD = Aw^2/(Nw^2*Be)*mean(PSDMatrix);       % il vettore della PSD (double side) è la media di ogni colonna di PSDMatrix (corretta con gli opportuni coefficienti Aw e Be)
f = (0:Nw-1)*fs/Nw;                         % vettore delle frequenze della trasformata di ogni spezzone di segnale

end

