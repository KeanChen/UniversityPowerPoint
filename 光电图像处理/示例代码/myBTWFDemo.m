%==========================================================================
% ��ѧ��ʾ���� ͼ�������˹(Butterworth)�˲�
%               Program Name: myBTWFDemo.m
%               Course:Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2018 Zhenming Peng
% IDIPLAB,
% School of Information and communication engineering,
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
%
% Revised:2018.10.22
% =========================================================================
clc,clear all,close all
f = imread('rice.png');
[M, N]= size(f);
imshow(f),title('ԭʼͼ��');
% =========================================================================
% zeros padding,such as [256,256]->[512,512]
% =========================================================================
P = 2*M; Q = 2*N;
fp = zeros(P,Q);
fp(1:M, 1:N) = f;

% =========================================================================
% FFT+Ƶ�����Ļ�
% =========================================================================
Fp = fftshift(fft2(fp));
%Fp = fftshift(fft2(double(f),P,Q)); ����FFT�Զ�����

% =========================================================================
% Build the Butterworth filter in frequence domain
% =========================================================================
%�趨��ֹƵ��
D0 = 60; n = 3;

% Ԥ�����ڴ�
Hp = zeros(P,Q);
for u = 1:P
    for v = 1:Q
        D = sqrt((u-1-P/2).^2+(v-1-Q/2).^2);  % ���ģ������Գ��˲���
        Hp(u,v) = 1./(1+(D./D0).^(2*n)); % lowpass
        %Hp(u,v) = 1./(1+(D0./D).^(2*n)); % highpass       
    end
end

% 2D�˲���Ƶ��
figure,imshow(Hp,[]),title('Butterworth 2D�˲�����Ӧ');

% =========================================================================
% �����µ�x-y����3D�˲���Ƶ��
% =========================================================================
dr = 0.5; dc = 0.5;
Fx = ((0:Q-1)-floor(Q/2))/(Q*dc);
Fy = ((0:P-1)-floor(P/2))/(P*dr);
[Fx,Fy] = meshgrid(Fx, Fy);
figure,surfl(Fx,Fy,Hp(1:P,1:Q));%title('3D�����˲�����Ӧ')
xlabel('u'), ylabel('v'), zlabel('H(u,v)'),grid on
xlim([min(Fx(:)) max(Fx(:))]),ylim([min(Fx(:)) max(Fx(:))])
%xlabel('Fx'), ylabel('Fy'), zlabel('Magnitude'),grid on
shading interp,colormap copper

% Ƶ���˲�
Gp = Hp .* Fp;

% �����Ļ�+����Ҷ���任
gp = real(ifft2(ifftshift(Gp)));
% =========================================================================
% Ƶ�׷����Ļ�
% =========================================================================

figure,imshow(uint8(gp)),title('����ͼ���˲����');

% ����ͼ���н�ȡ��Ҫ�Ĳ���
gpi = gp(1:M, 1:N);
figure,imshow(uint8(gpi)),title('�����˲����');