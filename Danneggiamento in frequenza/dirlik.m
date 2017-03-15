function [ damageIntensity ] = dirlik( f,PSDstress,C,k )
%DIRLIK calcola il danneggiamento secondo il metodo di Dirlik
%   La durata in (s) si ricava da (damageIntensity)^-1
%   
%   f = vettore delle frequenze (Hz)
%   PSDstress = vettore della PSD single side delle tensioni (Pa)
%   C = costante della curva di Basquin del materiale
%   k = pendenza della curva di Wohler

% momenti statistici della PSD
m0 = trapz(f, PSDstress);
m1 = trapz(f, f.*PSDstress);
m2 = trapz(f, f.^2.*PSDstress);
m4 = trapz(f, f.^4.*PSDstress);



xm = m1/m0*sqrt(m2/m4);
alfa2 = m2/sqrt(m0*m4);

G1 = 2*(xm-alfa2^2)/(1+alfa2^2);
R = (alfa2-xm-G1^2)/(1-alfa2-G1+G1^2);
G2 = (1-alfa2-G1+G1^2)/(1-R);
G3 = 1-G1-G2;
Q = 1.25*(alfa2-G3-G2*R)/G1;
np = sqrt(m4/m2);

damageIntensity = C^-1*np*m0^(k/2)*(G1*Q^k*gamma(1+k)+2^(k/2)*gamma(1+k/2)*(G2*abs(R)^k+G3));

end

