%==========================================================================
% Demo��ͼ���/Ƶ���˲�һ���Բ��Դ���
%       Program name: mySFFilt2Demo.m
%       Course:Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2017 Zhenming Peng
% GISPALAB
% School of Opto-Electronic Information, 
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
%
% Revised: 2017.11.12
%==========================================================================
clc;clf;clear all;close all;
%==========================================================================
img = imread('Fig0526(a)(original_DIP).tif'); % Fig0438(a)(bld_600by600).tif cameraman.tif
img = im2double(img);
% subplot(131)
imshow(img,[]),title('Original image')
[M,N] = size(img);             % Original image size
%==========================================================================
% �����˲�������
%h = ones(3,3)/9;                      % average
%h = [-1 0 1;-2 0 2;-1 0 1];           % sobel
%h = [0 1 0;1 -4 1;0 1 0];             % laplacian
%h = fspecial('gaussian',9,2);         % gaussian
h = fspecial('motion',100,-45);        % motion
%==========================================================================
% �����˲�
gx = imfilter(img,h,'replicate');%'symmetric','circular','X'
% subplot(132)
figure, imshow(gx,[]);title('Spatial domain filtering')
%==========================================================================
% Ƶ���˲�
%==========================================================================
center_h = floor((size(h)+1)/2);        % ȷ���˲���h���ĵ�����
padsb = center_h + 1;                   % �������������
imp = padarray(img,[padsb(1),padsb(2)],'replicate'); % Padding border
PQ = 2*size(imp);
Fp = fft2(imp, PQ(1), PQ(2));           % ͼ�������غ�FFT
h  = rot90(h,2);                        % mask��ת180��

%Hp = fft2(h, PQ(1), PQ(2));            % �˲����������غ�FFT��δ��ѭ����λ��

%==========================================================================
% �˲������������Ƶ�������������Ͻ�
%==========================================================================
P = PQ(1); Q = PQ(2);
hp = zeros(P,Q);                       % ������PXQ����
hp(1:size(h,1), 1:size(h,2)) = h;      % ��������غ�h����hp���Ͻ�
%==========================================================================
% h���ĵ�����hp�����ϽǷ�ʽ֮һ ����ѡ��ʽ,��Чcircshift������
% row_indices = [center_h(1):P, 1:(center_h(1)-1)]'; 
% col_indices = [center_h(2):Q, 1:(center_h(2)-1)];
% hp = hp(row_indices, col_indices);  
%==========================================================================
% h���ĵ�����hp�����ϽǷ�ʽ֮��:ֱ�ӵ���matlab��ѭ����λ������
hp = circshift(hp,[-(center_h(1)-1),-(center_h(2)-1)]); 
%==========================================================================
Hp = fft2(hp);
%==========================================================================
%Hp = ifftshift(freqz2(rot90(h,2),P,Q)); % ����matlab��������Ƶ���˲��������Ļ���
%==========================================================================
Gp = Hp.*Fp;                        % Ƶ���˲�
gp = real(ifft2(Gp));               % ���任/ȡʵ��
%gf = gp(1:M,1:N);                  % �ü���Ч���ݣ���0�߽緽ʽ���ã�
gf = gp(padsb(1)+1:M + padsb(1),padsb(2)+1:N + padsb(2));   % �ü���Ч���ݣ������߽緽ʽ���ã�
%subplot(133)
figure, imshow(gf,[]),title('Frequency domain filtering')