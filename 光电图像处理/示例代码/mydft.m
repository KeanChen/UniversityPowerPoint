function y = mydft(x,n)
%==========================================================================
% MYDFT 1-D Discrete Fourier Transform
%--------------------------------------------------------------------------
%  x -  the input sequence
%  n -  the sample number of DFT
%  y -  the output sequence
%--------------------------------------------------------------------------
%
% Course: Optoelectronic Image Processing(OIP)
% Copyright (c) 2006-2018 Zhenming Peng
% IDIPLAB, 
% School of Information and communication engineering,
% University of Electronic Science and Technology of China
% http://gispalab.uestc.edu.cn/
%
% Revised: 2018.10.10
%==========================================================================

% �жϺ����Ƿ����������
if nargin == 0,
	error(generatemsgid('Nargchk'),'Not enough input arguments.');
end

% �ж�����x�Ƿ�Ϊ NULL
if isempty(x)
   y = [ ]; return;
end

% If input is a vector, make it a column:
do_trans = (size(x,1) == 1);
if do_trans, x = x(:); end

% ����n��ȱʡֵ����x����
if nargin == 1,
     n = size(x,1); % n��
end

l  = size(x,2);     % l��

% Pad or truncate input if necessary
if size(x,1) < n,
    xp = zeros(n,l);
    xp(1:size(x,1),:) = x;
else
    xp = x(1:n,:);
end

%--------------------------------------------------------------------------
% DFT key codes
%--------------------------------------------------------------------------
y = zeros(n,l);
for u = 1:n
    y(u) = 0;
    for k = 1:n
         y(u) = y(u) + xp(k)*exp(((-1i)*2*pi*(k-1)*(u-1))/n);
    end
end
%--------------------------------------------------------------------------

% Re-order the elements of the columns of x
if do_trans, y = y.'; end 