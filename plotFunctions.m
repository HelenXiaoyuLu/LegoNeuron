figure()
hold on
plot(-1:0.1:0,zeros(size(-1:0.1:0)),'color',[0, 0.4470, 0.7410])
plot(0:0.1:1,exp(-(0:0.1:1)/0.5),'color',[0, 0.4470, 0.7410])
plot(zeros(size(0:0.1:1)),0:0.1:1,'--k')
set(gca,'ytick',[],'ycolor','none','xticklabel',[])

figure()
hold on
plot(-2:0.1:2,exp(-(-2:0.1:2).^2),'color',[0, 0.4470, 0.7410])
% plot(zeros(size(0:0.1:1)),0:0.1:1,'--k')
set(gca,'ytick',[],'ycolor','none','xticklabel',[])

figure()
hold on
plot(-1:0.1:0,exp((-1:0.1:0)/0.5),'color',[0, 0.4470, 0.7410])
plot(0:0.1:1,exp(-(0:0.1:1)/0.5),'color',[0, 0.4470, 0.7410])
plot(zeros(size(0:0.1:1)),0:0.1:1,'--k')
set(gca,'ytick',[],'ycolor','none','xticklabel',[])

figure()
hold on
plot(-2:0.1:2,tanh(-2:0.1:2),'color',[0, 0.4470, 0.7410])
plot(-2:0.1:2,-tanh(-2:0.1:2),'color',[0, 0.4470, 0.7410])
% plot(zeros(size(-1:0.1:1)),-1:0.1:1,'--k')
set(gca,'ytick',[],'ycolor','none','xticklabel',[])