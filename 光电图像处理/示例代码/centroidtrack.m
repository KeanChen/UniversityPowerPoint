clc;clear all; close all;
%======================================================
path = '.\image200s';        % �����ļ�·��
totalfrm = 200;                    % ����ͼ����֡��

%======================================================
% ��֡ѭ������
%======================================================
for i = 1 : totalfrm
    if  i <= 9
        I = imread([path '\0000000', num2str(i) '.bmp']);
    else if  i <= 99
            I = imread([path '\000000', num2str(i) '.bmp']);
        else
            I = imread([path '\00000', num2str(i) '.bmp']);
        end
    end
    imshow(I), title(['��#' num2str(i) 'ͼ��']);   hold on

    I = uint8(I);
    [m,n] = size(I);
    bw = zeros(m,n);
    for j = 1:n   % ͼ���ֵ��
        for k = 1:m
            if I(k,j) > 200
                bw(k,j) = 255;
            else
                bw(k,j) = 0;
            end
        end
    end
    E = uint8(bw);
    [m,n] = find(E==0);
    M = [m,n];
    N = M(M(:,2)<480,:);                        % ȥ��Ե��
    Y = fix(mean(N(:,1)));
    X = fix(mean(N(:,2)));
    plot(X,Y,'g*'), hold on
    %�ӱ߿�
    xu = 38;                                      % ���ŵİ�߶�
    yu = 16;                                      % ���ŵİ볤��
    XX = [X-xu  X-xu  X+xu   X+xu   X-xu ];       % �����ĸ����λ������
    YY = [Y-yu  Y+yu  Y+yu   Y-yu   Y-yu ];
    line(XX,YY);                                % ����
    text (360,260,sprintf('����(%3.2f,%3.2f)',X,Y));   %��ͼ����ʵʱ��ʾ����λ��
    %title (sprintf('����(%3.2f,%3.2f)',X,Y));    
    pause(0.001); %������ͣ
end
%======================================================
