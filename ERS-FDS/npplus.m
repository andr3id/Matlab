function [ npplus ] = npplus( zpuntoRMS, z2puntiRMS )
%npPlus calcola il numero medio di massimi di un segnale z(t) in un secondo,
%in funzione delle possibili frequenze naturali f0 di un sistema SDOF.
%Il calcolo si basa sull'analisi statistica del segnale z(t) che deve essere
%random gaussiano.
%   npplus = npplus(zpuntoRMS,z2puntiRMS)
%
%   zpuntoRMS = valore RMS della velocità zpunto(t) in funzione di f0
%   z2puntiRMS = valore RMS dell'accelerazione z2punti(t) in funzione di f0

npplus = z2puntiRMS./(2*pi*zpuntoRMS);      % vettore di lunghezza length(f0)

end