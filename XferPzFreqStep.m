OmegaMax=10;        %Limits on omega for plot
OmegaMin=0.1;       %(OmegaMin used for Bode plot -- freq can't go to zero
                    %  because x axis is log of omega).
SigmaMax=5;         %Limit on sigma for plot
DOmega=0.1;         %Increment in omega for plots
DSigma=0.1;         %Increment in sigma for plots
AMax=10;             %Max value for plotting of Transfer function.
AMin=1/100;
%Define sigma and omega and find length of vectors.
omega=-OmegaMax:DOmega:OmegaMax;
sigma=-(0:DSigma:SigmaMax);
O=length(omega);
S=length(sigma);


%Define some transfer functions.
wn=1;
zeta=0.1;

sys=tf(1,[1 1]);
sys=tf(3,[1 3]);
sys=tf([0 0 wn*wn],[1 2*zeta*wn wn*wn]);
sys=tf([1 0 0],[1 2*zeta*wn wn*wn]);
sys=tf([1 0 wn*wn],[1 2*zeta*wn wn*wn]);
sys=tf([0 2*zeta*wn 0],[1 2*zeta*wn wn*wn]);
sys=tf([0 0 wn*wn],[1 2*zeta*wn wn*wn]);

%Predefine size of array to speed things up.
z=zeros(O,S);
%Evaluate transfer function at all values of s=sigma+j*omega.
for o=1:O
    for s=1:S
        z(o,s)=abs(evalfr(sys,sigma(s)+j*omega(o)));
        z(o,s)=min(z(o,s),AMax);    %Clip off high values of transfer function (for plotting)
    end
end
subplot(221);
q=surf(sigma,omega,z);
set(q,'EdgeColor','none')
set(q,'FaceColor','interp')
view([120 30])
hold on
%Plot freq response (s=j*omega -- sigma=0).
plot3(zeros(size(omega)),omega,z(:,1),'k','LineWidth',2)
%Plot location of poles and zeros.
[zer,pol,k]=zpkdata(sys,'v');
for i=1:length(zer),
    t=text(real(zer(i)),imag(zer(i)),'o');
    set(t,'color',[1 0 0]);
    set(t,'fontweight','bold');
end
for i=1:length(pol),
    t=text(real(pol(i)),imag(pol(i)),'x');
    set(t,'color',[1 0 0]);
    set(t,'fontweight','bold');
end
ylabel('Omega');
xlabel('Sigma');
zlabel('Abs(G(s))')
axis([-SigmaMax 0 -OmegaMax OmegaMax 0 AMax])
hold off



omega=OmegaMin:DOmega:OmegaMax;
sigma=-(0:DSigma:SigmaMax);
O=length(omega);
S=length(sigma);
z=zeros(O,S);;
for o=1:O
    for s=1:S
        z(o,s)=abs(evalfr(sys,sigma(s)+j*omega(o)));
        z(o,s)=min(z(o,s),AMax);
        z(o,s)=max(z(o,s),AMin);
    end
end
subplot(222);
q=surf(sigma,log10(omega),20*log10(z));
set(q,'EdgeColor','none')
set(q,'FaceColor','interp')
view([120 30])
hold on
plot3(zeros(size(omega)),log10(omega),20*log10(z(:,1)),'k','LineWidth',2)
ylabel('Log10(omega)');
xlabel('Sigma');
zlabel('Abs(G(s)), dB')
axis([-SigmaMax 0 log10(OmegaMin) log10(OmegaMax) 20*log10(AMin) 20*log10(AMax)])
hold off



subplot(223);
pzmap(sys)
xlabel('Sigma');
ylabel('Omega');
axis([-SigmaMax 0 -OmegaMax OmegaMax]);



subplot(224);
step(sys);