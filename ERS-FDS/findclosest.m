function [ index ] = findclosest( vector, value )
%findclosest ritorna l'indice dell'elemento pi� vicino a un certo valore
%all'interno di un array
%   ind = findclosest( v, val )
%   
%   v = vettore in cui fare la ricerca
%   val = valore da ricercare all'interno di v
%   ind = indice del valore all'interno del vettore v pi� prossimo a val

% FUNZIONAMENTO:
% sottraggo dal vettore il valore da ricercare (vector - value):
% il valore assoluto del vettore risultante d� un grafico con un punto
% angoloso in corrispondenza del valore minimo (il pi� vicino al valore 
% considerato).
% La function [a,b] = min(vettore) d� in output come a il valore minimo del
% vettore e come b la sua posizione (che � l'indice cercato).
% Sosituire a con ~ permette di non calcolare a dal momento che interessa
% solo il valore b.

[~, index] = min(abs(vector - value));

end

