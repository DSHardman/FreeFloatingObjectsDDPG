function x = CreateStochasticNoise(fmin,fmax,times,sig)
%Creates a stochastic process by summing sine waves with
%random phase. Adapted from example given in CUED module 4C7 lecture notes

%Derived parameters:
wmin = 2*pi*fmin;
wmax = 2*pi*fmax;
dw=2*pi/(times(end));
nw=floor((wmax-wmin)/dw); %number of sine wave components
nt=length(times); %number of timesteps
                
ph = zeros(nw,1);
w = zeros(nw,1);
for j=1:nw
    ph(j)=2*pi*rand;             %random phase of the j'th sine wave
    w(j)=wmin+(wmax-wmin)*j/nw;  %frequency of the j'th sine wave
end

x = zeros(nt,1);
for k=1:nt %sum random sine waves together to generate random signal
    res=0;
    for j=1:nw
        res=res+sig*sqrt(2/nw)*sin(w(j)*times(k)+ph(j));
    end
    x(k)=res;
end

end
