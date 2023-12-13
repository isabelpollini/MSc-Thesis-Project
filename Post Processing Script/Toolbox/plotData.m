%% 'plotData.m': 

figure('Color','w')
subplot(2,3,1)
plot(dataElab.alphaShift,dataElab.Fy)
hold on
grid on
xlabel('Alpha [deg]')
ylabel('Fy [N]')
title('Lateral force vs slip angle')

subplot(2,3,2)
plot(dataElab.alpha,dataElab.Mz)
hold on
grid on
xlabel('Alpha [deg]')
ylabel('Mz [N]')
title('Self-aligning moment vs slip angle')

subplot(2,3,4)
plot(dataElab.alpha,dataElab.Fz)
hold on
grid on
xlabel('Alpha [deg]')
ylabel('Fz [N]')
title('Vertical load vs slip angle')

subplot(2,3,5)
plot(dataElab.alphaShift,dataElab.Fy/dataTest.Fz0)
hold on
grid on
xlabel('Alpha [deg]')
ylabel('Fy/Fz_0 [N]')
title('Lateral force on nominal vertical load vs slip angle')

subplot(2,3,3)
plot(dataElab.time,dataElab.alpha,'Color','r')
hold on
% plot(dataF.time,dataF.alpha,'Color','g')
grid on
xlabel('Time [s]')
ylabel('Alpha [deg]')
legend('Motion Law')
title('Slip angle')

subplot(2,3,6)
plot(dataElab.time,dataElab.Fz)
hold on
grid on
xlabel('Time [s]')
ylabel('Fz [N]')
title('Vertical load')
