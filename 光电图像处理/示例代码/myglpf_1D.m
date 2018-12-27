%==========================================================================
%  ��ѧ��ʾ���� 1D Gaussian lowpass filetering in frequence domain
%                name:myglpf_1D.m
%                School of Opto-Electronic Information, University of
%                Electronic Science and Technology of China
%                Date: 2015.04.05
%                Author��zhenming peng
% =========================================================================
clc,clear all,close all;

% ========================================================================= 
% �����źŵĳ�ʼ�����趨
%==========================================================================
dt = 0.001; fs = 1/dt; fn = fs/2; L = 0.6;
%==========================================================================
% ��ɢ��ԭʼ�����źţ�����ԭʼ�ź�����
%==========================================================================
t = 0:dt:L;% ����������dt��ֵ��t�γ�һά����
% �����ʱ����Ӧ��x, xҲΪN+1��Ԫ�ص�����
x = sin(2*pi*10*t)+10*sin(2*pi*50*t)+5*sin(2*pi*120*t);

% �����˲����ԣ�ԭʼ�ź��м��������
y = x + 2.4*randn(size(t));

% ����ԭʼ�ź�/�����ź�����
%subplot(211)
plot(1000*t,y,'-b') % �̶ȣ�ms
%title('An initial signal')
title('Signal corrupted with zero-mean random noise')
xlabel('t/ms');ylabel('Amplitude')

% =========================================================================
% zeros padding,�������أ��Է�ֹƵ�ʾ�������
% =========================================================================
N = length(y);

% ����������2*N��
P = 2*N;
yp(1:P) = 0;
yp(1:N) = y;

% =========================================================================
% �������ʵ��Ƶ��Ƶ�����Ļ�(Spectrum Centralization)
% =========================================================================
for i = 1:P
    yp(i) = yp(i).*(-1)^(i); 
end

Fp = fft(yp);
%Fp = fftshift(Fp);
% =========================================================================
% Build 1D Gaussian lowpass filter in frequence domain
% ��ʽ��GLPF = exp(-D(u).^2/(2.D0.^2))
% =========================================================================
% �趨��ֹƵ��(cut-off frequency)
D0 = 120;
% Ԥ�����ڴ�
Hp(1:P) = 0;
for u = 1:P
    D = u - P/2-1;
    Hp(u) = exp(-(D.^2)/(2*(D0.^2))); 
end

% ���е�ͨ�˲�
Gp = Hp .* Fp; 

% �������еĸ���Ҷ���任
% Gp = ifftshift(Gp);
gp = real(ifft(Gp));
% =========================================================================
% Ƶ�׷����Ļ���inverse centralization for its spectrum��
% =========================================================================
for i = 1:P
    gp(i) = gp(i).*(-1)^(i); 
end

% ����������2N���н�ȡǰN�㣨ԭʼ�źų��ȣ�
gpi = gp(1:N);
%subplot(212)
hold on
plot(1000*t(1:N),gpi(1:N),'-r','LineWidth',2),title('Flitering result with GLPF');
xlabel('t/ms'),ylabel('Amplitude')
h = legend('Signal corrupted with zero-mean random noise','Flitering result with GLPF',1);
%set(h,'Interpreter','none')