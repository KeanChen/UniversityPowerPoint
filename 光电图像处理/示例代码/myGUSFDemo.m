%==========================================================================
%                Gaussian Filetering in Frequence Domain
% Name:myGUSFDemo.m
% Copyright (c) 2006-2018
% IDIPLAB,
% School of Information and communication engineering,
% Electronic Science and Technology of China
% Date: 2018.10.20
% Author��Zhenming Peng
% =========================================================================
clc,clear all,close all
f = imread('Fig0432(a)(square_original).tif');
[M, N]= size(f);
imshow(f),title('ԭʼͼ��');

% =========================================================================
% Zeros padding,such as [256,256]->[512,512]
% =========================================================================
P = M; Q = N;
fp = zeros(P,Q);
fp(1:M,1:N) = f; % ����ԭͼ��������Ͻǣ����ƣ���ѭ����ʽ����죩

% =========================================================================
% ����ʵ��Ƶ�����Ļ�
% =========================================================================
for i = 1:P
    for j = 1:Q
        fp(i,j) = fp(i,j).*(-1)^(i-1+j-1);
    end
end
Fp = fft2(fp);
%Fp = fftshift(Fp);
%Fp = fftshift(fft2(double(f),P,Q)); ����FFT�Զ�����

% =========================================================================
% Build the Gaussian filter in frequence domain
% =========================================================================

D0 = 200;         % �趨��ֹƵ��
Hp = zeros(P,Q); % Ԥ�����ڴ�/ȫ0Ԫ�ؾ���

for u = 1:P
    for v = 1:Q
        D = sqrt((u-1-P/2).^2+(v-1-Q/2).^2);
        Hp(u,v) = exp(-(D.^2)/(2*(D0^2)));
    end
end
%Hp = 1-Hp + 0.2;%  GHPF
figure,imshow(Hp),title('2D-Gaussian �˲�����Ӧ')

% =========================================================================
% �����µ�x-y����3D�˲���Ƶ��
% =========================================================================
dr = 0.8; dc = 0.8;
Fx = ((0:Q-1)-floor(Q/2))/(Q*dc);
Fy = ((0:P-1)-floor(P/2))/(P*dr);
[Fx,Fy] = meshgrid(Fx, Fy);
figure,surfl(Fx,Fy,Hp(1:P,1:Q));%title('3D�����˲�����Ӧ')
xlabel('u'), ylabel('v'), zlabel('H(u,v)'),grid on
xlim([min(Fx(:)) max(Fx(:))]),ylim([min(Fx(:)) max(Fx(:))])
%xlabel('Fx'), ylabel('Fy'), zlabel('Magnitude'),grid on
shading interp,colormap copper

% =========================================================================
% ���ʵ��Ƶ���˲�
Gp = Hp .* Fp;
% =========================================================================

% ����ͼ��ĸ���Ҷ���任
% Gp = ifftshift(Gp);
gp = real(ifft2(Gp)); % ȡʵ�������Լ������鲿����
% =========================================================================
% Ƶ�׷����Ļ�
% =========================================================================
for i = 1:P
    for j = 1:Q
        gp(i,j) = gp(i,j).*(-1)^(i-1+j-1);
    end
end
figure,imshow(uint8(gp)),title('����ͼ���˲����');

% ����ͼ���н�ȡ��Ҫ�Ĳ���
gpi = gp(1:M, 1:N);
figure,imshow(uint8(255*mat2gray(gpi)),[]),title('�����˲����');