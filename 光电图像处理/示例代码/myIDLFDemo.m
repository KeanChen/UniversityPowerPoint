%==========================================================================
% Demo: Idel Lowpass & Highpass Filtering in Frequency Domain
%       Program Name:myidelfilt.m
%       Course:Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2018 Zhenming Peng
% IDIPLAB,
% School of Information and communication engineering,
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
% 
% Include:
% Idel low-pass & highpass filtering
% Revised:2018.10.20
%==========================================================================
clc,clf,clear all,close all;
f = imread('rice.png');
[M, N] = size(f);                 % ԭʼͼ��ߴ�
imshow(f), title('ԭʼͼ��');

% =========================================================================
% Zeros padding,such as [256,256]->[512,512]
% =========================================================================
P = 2*M; Q = 2*N;   % ������ͼ��ߴ�
fp = zeros(P,Q);      % Ԥ�����ڴ�/ȫ0Ԫ�ؾ���double��
fp(1:M,1:N) = f;        % ����ԭͼ��������Ͻǣ����ƣ���ѭ����ʽ����죩

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

% =========================================================================
% Build the frequence domain filter
% =========================================================================

D0 = 200;              % �趨��ֹ(cutoff)Ƶ��

Hp = zeros(P,Q); % Ԥ�����ڴ�/ȫ0Ԫ�ؾ���
for u = 1:P
    for v = 1:Q
        D = sqrt((u-1-P/2).^2+(v-1-Q/2).^2);  % ���ģ������Գ��˲���
        if D <= D0
            Hp(u,v) =1.0;
        end
    end
end
%Hp = 1-Hp+0.8;       % �����ͨ(ILHF)
figure,imshow(Hp,[]),title('2-D�˲�����Ӧ')

% =========================================================================
% �����µ�x-y����3D�˲���Ƶ��
% =========================================================================
dr = 0.8; dc = 0.8;
Fx = ((0:Q-1)-floor(Q/2))/(Q*dc);
Fy = ((0:P-1)-floor(P/2))/(P*dr);
[Fx,Fy] = meshgrid(Fx, Fy);
figure,surfl(Fx,Fy,Hp(1:P,1:Q)); title('3-D�˲�����Ӧ')
xlabel('u'), ylabel('v'), zlabel('H(u,v)'),grid on
xlim([min(Fx(:)) max(Fx(:))]),ylim([min(Fx(:)) max(Fx(:))])
%xlabel('Fx'), ylabel('Fy'), zlabel('Magnitude'),grid on
shading interp,colormap pink %copper 

% =========================================================================
% Ƶ���˲�
Gp = Hp .* Fp;   % ���
% =========================================================================

% ���ͼ��ĸ���Ҷ���任
% Gp = ifftshift(Gp);
gp = real(ifft2(Gp));    % ȡʵ��
% =========================================================================
% Ƶ�׷����Ļ�
% =========================================================================
for i =1:P
    for j =1:Q
        gp(i,j) = gp(i,j).*(-1)^(i-1+j-1);
    end
end
figure,imshow(gp,[]),title('����ͼ���˲����');

% �������Ͻ���Чͼ��
gpi = gp(1:M, 1:N);
figure,imshow(gpi,[]),title('�����˲����');