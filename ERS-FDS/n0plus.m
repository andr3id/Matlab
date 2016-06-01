function [ n0plus ] = n0plus( zRMS, zpuntoRMS )
%n0plus calcola il numero medio di passaggi del livello 0 di un segnale
%z(t) in un secondo, in funzione delle possibili frequenze naturali f0 di
%un sistema SDOF.
%Il calcolo si basa sull'analisi statistica del segnale z(t) che deve essere
%random gaussiano.
%Per definizione si considerano solo i passaggi con pendenza positiva.
%   n0plus = n0plus(zRMS,zpuntoRMS)
%
%   zRMS = valore RMS dello spostamento random z(t) in funzione di f0
%   zpuntoRMS = valore RMS della velocità zpunto(t) in funzione di f0

n0plus = zpuntoRMS./(2*pi*zRMS);        % vettore di lunghezza length(f0)

end