function [ damageIntensity ] = narrowband( f,PSDstress,C,k )
%NARROWBAND calcola il danneggiamento utilizzando la formula di Rayleigh
%   La durata in (s) si ricava da (damageIntensity)^-1
%   
%   f = vettore delle frequenze (Hz)
%   PSDstress = vettore della PSD single side delle tensioni (Pa)
%   C = costante della curva di Basquin del materiale
%   k = pendenza della curva di Wohler

m0 = trapz(f,PSDstress);                        % momento m0 (= varianza della PSD) (Pa^2)
m2 = trapz(f,f.^2.*PSDstress);                  % momento m2 (Pa^2/s^2)
v0 = sqrt(m2/m0);                               % (Hz)

damageIntensity = v0/C*(sqrt(2*m0))^k*gamma(1+k/2);           % (adim.)
% D^-1 dà la durata (in s) del componente

end

