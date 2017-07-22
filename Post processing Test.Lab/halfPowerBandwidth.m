load('FRF_martellataPunta.mat')

f = FRF.x_values.start_value:FRF.x_values.increment:(FRF.x_values.number_of_values-1)*FRF.x_values.increment;
FRFamplitude = abs(FRF.y_values.values*FRF.y_values.quantity.unit_transformation.factor);
plot(f,FRFamplitude), grid on, xlabel('Hz'), ylabel('g/N')

[peakFRF, indexPeakFRF] = max(abs(FRFamplitude));   % valore di picco dell'FRF e relativo indice posizionale
fPeak = f(indexPeakFRF);                            % frequenza corrispondente al picco dell'FRF

halfPowerValue = peakFRF/sqrt(2);                   % valore di soglia della banda di mezza potenza

omega_s = 2*pi*fPeak;



% trovo gli indici dei valori dell'FRF superiori al valore di soglia
indexUpperThresholdFRF = find(FRFamplitude > halfPowerValue);
if isvector(indexUpperThresholdFRF)                 % testo se i valori dell'FRF che stanno sopra la soglia sono più di uno
    
    % punti a cavallo della soglia a SX della campana
    x1Left = f(indexUpperThresholdFRF(1) - 1);               % coordinate punto inferiore rispetto la soglia
    y1Left = FRFamplitude(indexUpperThresholdFRF(1) - 1);
    x2Left = f(indexUpperThresholdFRF(1));                   % coordinate punto superiore rispetto la soglia
    y2Left = FRFamplitude(indexUpperThresholdFRF(1));
    
    % punti a cavallo della soglia a DX della campana
    x1Right = f(indexUpperThresholdFRF(end));                % coordinate punto superiore rispetto la soglia
    y1Right = FRFamplitude(indexUpperThresholdFRF(end));
    x2Right = f(indexUpperThresholdFRF(end) + 1);             % coordinate punto inferiore rispetto la soglia
    y2Right = FRFamplitude(indexUpperThresholdFRF(end) + 1);
    
    % interpolazione lineare per trovare omega1 e omega2 (estremi della
    % banda di mezza potenza sull'asse delle ascisse
    omega1 = 2*pi*(((x2Left - x1Left)/(y2Left - y1Left))*(halfPowerValue - y1Left) + x1Left);
    omega2 = 2*pi*(((x2Right - x1Right)/(y2Right - y1Right))*(halfPowerValue - y1Right) + x1Right);
    
else                                                        % caso particolare: ho solo 1 punto che sta sopra la soglia
    x1Left = f(indexUpperThresholdFRF - 1);
    y1Left = FRFamplitude(indexUpperThresholdFRF - 1);
    x2Left = f(indexUpperThresholdFRF);
    y2Left = FRFamplitude(indexUpperThresholdFRF);
    
    x1Right = x2Left;
    y1Right = y2Left;
    x2Right = f(indexUpperThresholdFRF + 1);
    y2Right = FRFamplitude(indexUpperThresholdFRF + 1);
    
    % interpolazione lineare
    omega1 = 2*pi*(((x2Left - x1Left)/(y2Left - y1Left))*(halfPowerValue - y1Left) + x1Left);
    omega2 = 2*pi*(((x2Right - x1Right)/(y2Right - y1Right))*(halfPowerValue - y1Right) + x1Right);
end


zita = (omega2^2 - omega1^2)/(4*omega_s^2);
fprintf(1, 'Fattore di smorzamento:\t %g\n', zita);
