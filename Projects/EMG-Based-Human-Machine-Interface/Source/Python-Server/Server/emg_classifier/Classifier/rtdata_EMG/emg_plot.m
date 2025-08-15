t = [1:size(nrm)]/1000;
fs = 2000;

figure 
grid on
box on
hold on
plot(t,nrm.ch1,'Linewidth',1)
plot(t,nrm.ch2,'Linewidth',1)
plot(t,nrm.ch3,'Linewidth',1)
plot(t,nrm.ch4,'Linewidth',1)
set(gca,'fontsize', 18)
ylim([0,100])
xlabel('Time (Second)')
ylabel('Normalized EMG Signal (%)')
title('Direct Control')
legend('ED','ECRL','FD','FCR')
xlim([0,12.7])

figure 
subplot(4,1,1)
grid on
box on
hold on
plot(t,nrm.ch1,'Linewidth',1,'Color',[0, 0.4470, 0.7410])
set(gca,'fontsize', 16)
set(gca,'xticklabel',{[]})
ylim([0,100])
xlim([3,11])

subplot(4,1,2)
grid on
box on
hold on
plot(t,nrm.ch2,'Linewidth',1,'Color',[0.8500, 0.3250, 0.0980])
set(gca,'fontsize', 16)
set(gca,'xticklabel',{[]})
ylim([0,100])
xlim([3,11])

subplot(4,1,3)
grid on
box on
hold on
plot(t,nrm.ch3,'Linewidth',1,'Color',[0.9290, 0.6940, 0.1250])
set(gca,'fontsize', 16)
set(gca,'xticklabel',{[]})
ylim([0,100])
xlim([3,11])

subplot(4,1,4)
grid on
box on
hold on
plot(t,nrm.ch4,'Linewidth',1,'Color',[0.4940, 0.1840, 0.5560])
set(gca,'fontsize', 16)
ylim([0,100])
xlim([3,11])
