%==========================================================================
% ��ѧ��ʾ���� Build the Frequency Filter from the Small Mmask 
%               in Spatial Domain
%               Program Name: myfreqz2.m
%               Course:Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2017 Zhenming Peng
% GISPALAB
% School of Opto-Electronic Information, 
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
%
% Revised:2017.10.24
% =========================================================================

clc,clf,clear all,close all; 
% =========================================================================
% �����˲�������
% =========================================================================
h1 = [-1 0 1;-2 0 2;-1 0 1];  %  Sobel filter with x-direction(odd)
h2 = ones(9,9);               %  Average filter(even)
h3 = [1  4  7  4 1
         4 16 26 16 4
         7 26 41 26 7
         4 16 26 16 4
        1  4  7  4 1];         % Gaussian filter(even)
h4 = [0 -1  0
        -1  4 -1
        0 -1  0];              % Laplace filter(even)
% =========================================================================
h0 = h3;          % ѡ������Ŀ����˲���
if sum(h0(:))~= 0
    h0 = h0/sum(h0(:)); % �˲���ϵ��������һ���˲���Ӧ
end
h = rot90(h0,2); % Unrotate filter since FIR filters are rotated.
center_h = ceil((size(h) + 1)/2); % ȷ���˲������ĵ����꣨r,c��
% =========================================================================

Nr = 256; Nc = 256;  % �����ĳߴ�(��/����)�������ݴ�����ͼ��ĳߴ�ı䣡
% =========================================================================
hp = zeros(Nr,Nc);
hp(1:size(h,1),1:size(h,2)) = h;  % right-down parts with zeros padding
% =========================================================================
% h���ĵ�����hp�����ϽǷ�ʽ֮һ ����ѡ��ʽ,��Чcircshift������
% Circularly shift h to put the center element at the upper left corner.
row_indices = [center_h(1):Nr, 1:(center_h(1)-1)]';
col_indices  = [center_h(2):Nc, 1:(center_h(2)-1)]';
hp = hp(row_indices, col_indices);

% =========================================================================
% h���ĵ�����hp�����ϽǷ�ʽ֮��:ֱ�ӵ���matlab��ѭ����λ������
% hp = circshift(hp,[-(center_h(1)-1),-(center_h(2)-1)]); 
% =========================================================================

H = fftshift(fft2(hp));      % Ƶ��ԭ�����Ļ�

% Convert to real if possible
% ʱ��fʵ/ż��������ӦƵ��FΪʵ/ż����
if all(max(abs(imag(H)))<sqrt(eps)) 
    H = real(H);              % ��ȡʵ��
end

% Also check if the response is all imaginary
% ʱ��fʵ/�溯������ӦƵ��F��/�溯��
if all(max(abs(real(H)))<sqrt(eps))
    %H = complex(0,imag(H));   % ʵ������
    H = imag(H);               % ��ȡ�鲿
end

%subplot(122)
imshow(H,[]);             % ��ʾʵ�����鲿����,��������֮�֡�
%imshow(abs(H),[]);       % ��ʾʵ�����鲿����
title('2-D frequency response');
% =========================================================================
% ����x-y������ʾ�˲���3DƵ����Ӧ
% =========================================================================
dr = 0.8; dc = 0.8;
x = ((0:Nc-1)-floor(Nc/2))/(Nc*dc); %��
y = ((0:Nr-1)-floor(Nr/2))/(Nr*dr); %��
[Fx,Fy] = meshgrid(x, y);
figure,mesh(Fx,Fy,H(1:Nr,1:Nc));title('3-D frequency response');
%figure,mesh(Fx,Fy,abs(H(1:Nr,1:Nc)));
xlabel('Fx'), ylabel('Fy'), zlabel('Magnitude'),grid on

% =========================================================================
Hm = freqz2(h0,[Nr Nc]);   % or freqz2(h0,Nc,Nr])-MATLAB��������Ӧ����FIR�˲�����;
% =========================================================================
if all(max(abs(imag(Hm)))<sqrt(eps)) 
    Hm = real(Hm); % even��ȡʵ��
end
if all(max(abs(real(Hm)))<sqrt(eps))
    Hm = imag(Hm); % odd�� ȡ�鲿
end
figure,mesh(Fx,Fy,Hm(1:Nr,1:Nc)); 
title('3-D frequency response using matlab freqz2');