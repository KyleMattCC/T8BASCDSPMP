function  out_sig = equalizer(x, fs, gain1, gain2, gain3, gain4, gain5, gain6, gain7)
%
%  usage: out_sig   = equalizer(x, fs, gain1, gain2, gain3, gain4, gain5, gain6, gain7)
%               x   = input signal
%               fs  = sampling frequency
%  gain1 to gain7   = The gain for each nub 
%
A = fir1(1000,[20 100]/(fs/2),'bandpass');
filtA = filter(A,1,x);

B = fir1(1000,[100 200]/(fs/2),'bandpass');
filtB = filter(B,1,x);

C = fir1(1000,[200 600]/(fs/2),'bandpass');
filtC = filter(C,1,x);

D = fir1(1000,[600 1400]/(fs/2),'bandpass');
filtD = filter(D,1,x);

E = fir1(1000,[1400 3400]/(fs/2),'bandpass');
filtE = filter(E,1,x);

F = fir1(1000,[3400 8600]/(fs/2),'bandpass');
filtF = filter(F,1,x);

G = fir1(1000,[8600 21400]/(fs/2),'bandpass');
filtG = filter(G,1,x);

%g1 = 10^(gain1/20);
%g2 = 10^(gain2/20);
%g3 = 10^(gain3/20);
%g4 = 10^(gain4/20);
%g5 = 10^(gain5/20);
%g6 = 10^(gain6/20);
%g7 = 10^(gain7/20);

out_sig = filtA*gain1 + filtB*gain2 +filtC*gain3 + filtD*gain4 + filtE*gain5 + filtF*gain6 + filtG*gain7; 

%soundsc(out_sig,fs);
%X = fft(filtered,1024);
%X = fftshift(X);
%plot(abs(X));