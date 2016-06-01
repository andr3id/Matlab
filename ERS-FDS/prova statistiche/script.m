% SCRIPT PER CONFRONTARE COME LA LUNGHEZZA DI UNO SPEZZONE DI SEGNALE
% INFLUENZA LE STATISTICHE DI ERS/FDS DELLA RISPOSTA
% ====================================================================

% carico il segnale dell'accelerazione dell'eccitazione (1h di segnale
% random gaussiano broadband campionato a 2kHz).
% La PSD che da cui è stato generato ha la forma:
% 0 - 300Hz:    35 (m/s^2)^2/Hz
% 300 - 600Hz:  100 (m/s^2)^2/Hz
% 600 - 1000Hz: 20 (m/s^2)^2/Hz
load 1hour.mat
t = 0:deltat:T;         % vettore del tempo ricostruito (s)

% spezzoni di segnale di diversa lunghezza:
pos_2min = findclosest(t,60*2);
pos_4min = findclosest(t,60*4);
pos_8min = findclosest(t,60*8);
pos_16min = findclosest(t,60*16);
pos_32min = findclosest(t,60*32);

x_2min = x(1:pos_2min);
x_4min = x(1:pos_4min);
x_8min = x(1:pos_8min);
x_16min = x(1:pos_16min);
x_32min = x(1:pos_32min);

% PSD double side di ogni spezzone di segnale
% NB: la seguente procedura non ha senso nella pratica perché quando si usa
% una tavola vibrante si conosce già in partenza la PSD dell'eccitazione...
% Questa procedura è utile solo nel caso in cui si vuole studiare l'effetto
% affaticante di una vibrazione su un sistema SDOF e ci interessa capire
% quanto lungo considerare il segnale x(t)
[PSD_2min, fwelch_2min] = PSDWelch(x_2min,fs,1024,50);
[PSD_4min, fwelch_4min] = PSDWelch(x_4min,fs,1024,50);
[PSD_8min, fwelch_8min] = PSDWelch(x_8min,fs,1024,50);
[PSD_16min, fwelch_16min] = PSDWelch(x_16min,fs,1024,50);
[PSD_32min, fwelch_32min] = PSDWelch(x_32min,fs,1024,50);


% caratteristiche del sistema SDOF
zita = 0.05;
f0 = 1:5:2000;                  % possibili freq. nat. del sistema


% *******************************************
% STUDIO DELLA RISPOSTA z(t) DEL SISTEMA
% *******************************************

% RMS dello spostamento
zRMS_2min = zRMS(zita,f0,PSD_2min,fwelch_2min);
zRMS_4min = zRMS(zita,f0,PSD_4min,fwelch_2min);
zRMS_8min = zRMS(zita,f0,PSD_8min,fwelch_2min);
zRMS_16min = zRMS(zita,f0,PSD_16min,fwelch_2min);
zRMS_32min = zRMS(zita,f0,PSD_32min,fwelch_2min);

figure, plot(f0,zRMS_2min, f0,zRMS_4min, f0,zRMS_8min, f0,zRMS_16min, f0, zRMS_32min),
grid on, xlabel('f0 (Hz)'), ylabel('zRMS')
legend('2 min','4 min','8 min','16 min','32 min')

% RMS della velocità
zpuntoRMS_2min = zpuntoRMS(zita,f0,PSD_2min,fwelch_2min);
zpuntoRMS_4min = zpuntoRMS(zita,f0,PSD_4min,fwelch_2min);
zpuntoRMS_8min = zpuntoRMS(zita,f0,PSD_8min,fwelch_2min);
zpuntoRMS_16min = zpuntoRMS(zita,f0,PSD_16min,fwelch_2min);
zpuntoRMS_32min = zpuntoRMS(zita,f0,PSD_32min,fwelch_2min);

figure, plot(f0,zpuntoRMS_2min, f0,zpuntoRMS_4min, f0,zpuntoRMS_8min, f0,zpuntoRMS_16min, f0, zpuntoRMS_32min),
grid on, xlabel('f0 (Hz)'), ylabel('zpuntoRMS')
legend('2 min','4 min','8 min','16 min','32 min')

% RMS dell'accelerazione
z2puntiRMS_2min = z2puntiRMS(zita,f0,PSD_2min,fwelch_2min);
z2puntiRMS_4min = z2puntiRMS(zita,f0,PSD_4min,fwelch_2min);
z2puntiRMS_8min = z2puntiRMS(zita,f0,PSD_8min,fwelch_2min);
z2puntiRMS_16min = z2puntiRMS(zita,f0,PSD_16min,fwelch_2min);
z2puntiRMS_32min = z2puntiRMS(zita,f0,PSD_32min,fwelch_2min);

figure, plot(f0,z2puntiRMS_2min, f0,z2puntiRMS_4min, f0,z2puntiRMS_8min, f0,z2puntiRMS_16min, f0, z2puntiRMS_32min),
grid on, xlabel('f0 (Hz)'), ylabel('z2puntiRMS')
legend('2 min','4 min','8 min','16 min','32 min')

% numero medio di attraversamenti dello 0 (con pendenza positiva) al
% secondo
n0plus_2min = n0plus(zRMS_2min,zpuntoRMS_2min);
n0plus_4min = n0plus(zRMS_4min,zpuntoRMS_4min);
n0plus_8min = n0plus(zRMS_8min,zpuntoRMS_8min);
n0plus_16min = n0plus(zRMS_16min,zpuntoRMS_16min);
n0plus_32min = n0plus(zRMS_32min,zpuntoRMS_32min);

figure, plot(f0,n0plus_2min, f0,n0plus_4min, f0,n0plus_8min, f0,n0plus_16min, f0, n0plus_32min),
grid on, xlabel('f0 (Hz)'), ylabel('n_0^+')
legend('2 min','4 min','8 min','16 min','32 min')

% numero medio di picchi positivi al secondo
npplus_2min = npplus(zpuntoRMS_2min,z2puntiRMS_2min);
npplus_4min = npplus(zpuntoRMS_4min,z2puntiRMS_4min);
npplus_8min = npplus(zpuntoRMS_8min,z2puntiRMS_8min);
npplus_16min = npplus(zpuntoRMS_16min,z2puntiRMS_16min);
npplus_32min = npplus(zpuntoRMS_32min,z2puntiRMS_32min);

figure, plot(f0,npplus_2min, f0,npplus_4min, f0,npplus_8min, f0,npplus_16min, f0, npplus_32min),
grid on, xlabel('f0 (Hz)'), ylabel('n_p^+')
legend('2 min','4 min','8 min','16 min','32 min')

% fattore di irregolarità

r_2min = n0plus_2min./npplus_2min;
r_4min = n0plus_4min./npplus_4min;
r_8min = n0plus_8min./npplus_8min;
r_16min = n0plus_16min./npplus_16min;
r_32min = n0plus_32min./npplus_32min;

figure, plot(f0,r_2min, f0,r_4min, f0,r_8min, f0,r_16min, f0, r_32min),
grid on, xlabel('f0 (Hz)'), ylabel('r')
legend('2 min','4 min','8 min','16 min','32 min')
