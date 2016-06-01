function [ yFiltered ] = bandPass( y, t, fmin, fmax )
%bandPass esegue un filtro passa banda di un segnale
%   segnale filtrato = bandPass(y, fmin, fmax)
%   y = segnale da filtrare
%   t = vettore del tempo                   (s)
%   fmin = frequenza di taglio inferiore    (Hz)
%   fmax = frequenza di taglio superiore    (Hz)

N = length(y);
fs = 1/(t(2)-t(1));

bandIndexes = [floor(fmin*N/fs) : floor(fmax*N/fs)];        % vettore degli indici delle frequenze della banda passante

spectrum = fft(y);                                          % non occorre dividere per N perché successivamente dovrei rimoltiplicare per N
spectrumFiltered = zeros(size(spectrum));                   % preallocco un nuovo vettore che conterrà lo spettro filtrato
spectrumFiltered(bandIndexes) = spectrum(bandIndexes);      % copio la parte di spettro corrispondente agli indici della banda passante nel vettore dello spettro filtrato
spectrumFiltered(end+2-fliplr(bandIndexes)) = spectrum(end+2-fliplr(bandIndexes));  % siccome lo spettro è double side, copio anche la parte di spettro della banda passante specchiata rispetto la freq. di Nyquist

yFiltered = ifft(spectrumFiltered);


end

