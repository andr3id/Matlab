% SCRIPT PER LA CREAZIONE DI UNA SOL111 IN NASTRAN CON INPUT RANDOM
% =================================================================

% variabili:
title = 'titolo dell''analisi';
nodoEccitazione = 12339;
direzioneEccitazione = 'T2';
nodiOutput = 3313;
direzioneOutput = 'T2';
elementi = 2978;
componenteStress = 8;
minEigenvalue = 1;
maxEigenvalue = 3300;
freqZitaMin = 0;
freqZitaMax = 9999;
zita = 0.02;
G2m_s2Conversion = 9.80665;
interpolation = 'LOG';               % LINEAR o LOG
freqMin = 200;
freqMax = 250;
deltaf = 0.5;
numPoints = 31;
fileGeometria = 'geometry.dat';

% crazione del file da risolvere con Nastran:
fid = fopen('SOL111-RANDOM.dat','w','ieee-le','windows-1252');
fprintf(fid,'$           ************* EXECUTIVE CONTROL SECTION *************\r\n');
fprintf(fid,'SOL 111\r\n');
fprintf(fid,'CEND\r\n');
fprintf(fid,'$\r\n');
fprintf(fid,'$\r\n');
fprintf(fid,'$           ************* CASE CONTROL SECTION *************\r\n');
fprintf(fid,'TITLE = %s\r\n', title);
fprintf(fid,'$\r\n');
fprintf(fid,'ECHO = NONE\r\n');
fprintf(fid,'SET 907 = %g,%g\r\n', nodoEccitazione, nodiOutput);
fprintf(fid,'SET 908 = %g\r\n', elementi);
fprintf(fid,'$\r\n');
fprintf(fid,'   SPC = 666\r\n');
fprintf(fid,'   FREQ = 604\r\n');
fprintf(fid,'   SDAMPING = 111\r\n');
fprintf(fid,'   DLOAD = 103\r\n');
fprintf(fid,'   METHOD = 219\r\n');
fprintf(fid,'   RANDOM = 99\r\n');
fprintf(fid,'ACCELERATION(PUNCH,PSDF) = 907\r\n');
fprintf(fid,'STRESS(PUNCH,PSDF) = 908\r\n');
fprintf(fid,'MEFFMASS = YES\r\n');
fprintf(fid,'RESVEC = YES\r\n');
fprintf(fid,'AUTOSPC = YES\r\n');
fprintf(fid,'$\r\n');
fprintf(fid,'OUTPUT(XYPLOT)\r\n');
fprintf(fid,'   XYPEAK,XYPUNCH,ACCE,PSDF / %g(%s),%g(%s)\r\n', nodoEccitazione, direzioneEccitazione, nodiOutput, direzioneOutput);
fprintf(fid,'   XYPEAK,XYPUNCH,STRESS,PSDF / %g(%g)\r\n', elementi, componenteStress);
fprintf(fid,'$\r\n');
fprintf(fid,'$\r\n');
fprintf(fid,'$           ************* BULK DATA SECTION *************\r\n');
fprintf(fid,'BEGIN BULK\r\n');
fprintf(fid,'$.......2.......3.......4.......5.......6.......7.......8.......9.......0\r\n');
fprintf(fid,'$\r\n');
fprintf(fid,'EIGRL,219,%g,%g,,,,,MASS\r\n', minEigenvalue, maxEigenvalue);
fprintf(fid,'$\r\n');
fprintf(fid,'SPC1,666,123456,%g\r\n', nodoEccitazione);
fprintf(fid,'$\r\n');
fprintf(fid,'TABDMP1, 111, CRIT\r\n');
fprintf(fid,'+, %g, %g, %g, %g, ENDT\r\n', freqZitaMin, zita, freqZitaMax, zita);
fprintf(fid,'$\r\n');
fprintf(fid,'RLOAD1,103,133, , , 11, ,ACCE\r\n');

switch direzioneEccitazione
    case 'T1'
        dirEccitazioneSPCD = 1;
    case 'T2'
        dirEccitazioneSPCD = 2;
    case 'T3'
        dirEccitazioneSPCD = 3;
end

fprintf(fid,'SPCD,133,%g,%g,%g\r\n', nodoEccitazione, dirEccitazioneSPCD, G2m_s2Conversion);
fprintf(fid,'TABLED1,11\r\n');
fprintf(fid,'+,%g,1.0,%g,1.0,ENDT\r\n', freqZitaMin, freqZitaMax);
fprintf(fid,'RANDPS,99, 1, 1, 1.0, 0.0, 25\r\n');
fprintf(fid,'TABRND1, 25, %s, %s\r\n', interpolation, interpolation);
fprintf(fid,'+, .0, .0, 199.9, .0, 200., 1., 250., 1.\r\n');
fprintf(fid,'+, 250.1, .0, 3300., .0, ENDT\r\n');
fprintf(fid,'$\r\n');
fprintf(fid,'FREQ1,604,%g,%g,%g\r\n', freqMin, deltaf, (freqMax-freqMin)/deltaf);
fprintf(fid,'FREQ4,604,%g,%g,%g,%g\r\n', freqMin, freqMax, zita, numPoints);
fprintf(fid,'$\r\n');
fprintf(fid,'INCLUDE ''%s''\r\n', fileGeometria);
fprintf(fid,'$\r\n');
fprintf(fid,'ENDDATA\r\n');
fclose(fid);
