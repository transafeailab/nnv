

% lb = -1.3263;
% ub = 6.9903; 
lb = -3;
ub = 1;
logsig_over_approximation(lb,ub);

% plot the our approximation technique corresponding to the value of a, b

function logsig_over_approximation(lb, ub)
if ub <= lb
    error('Invalid lower bound and upper bound');
end

de =(ub - lb)/10;
x = lb:de:ub; 
figure; 
if lb >= 0 || ub <= 0 % case 1: lb >= 0 || ub <= 0
    
%     % plot axis
%     n = length(x);
%     y = zeros(1, n);
%     plot(x, y);
%     hold on;
%     dy = (logsig(ub) - logsig(lb))/10;
%     y = logsig(lb):dy:logsig(ub);
%     n = length(y);
%     x1 = zeros(1,n);
%     plot(x1,y);
    
    % plot logsig cure
    y = logsig(x);
    plot(x, y, '-*', 'Color', 'b');
    hold on;
    % plot tangent line at lb 
    a = logsig('dn', lb);
    y = a.*(x - lb) + logsig(lb);
    plot(x, y, 'r');
    hold on;
    % plot tangent line at ub 
    a = logsig('dn', ub);
    y = a.*(x - ub) + logsig(ub);
    plot(x, y, 'r');
    hold on;
    
    % plot connect line between lb and ub
    a = (logsig(ub) - logsig(lb))/(ub - lb);
    y = a.*(x-lb) + logsig(lb);
    plot(x,y, 'r');
    
    
    
elseif lb <0 && ub > 0 % case 3: lb <0 & ub > 0
    
%     % plot axis
%     n = length(x);
%     y = zeros(1, n);
%     plot(x, y, 'r');
%     hold on;
%     y = -0.1:0.1:1;
%     n = length(y);
%     x1 = zeros(1,n);
%     plot(x1,y, 'r');
%     
%     hold on;
    
    % plot logsig cure
    y = logsig(x);
    plot(x, y, '-*', 'Color', 'b');
    hold on;
    % plot tangent line at lb 
    a = logsig('dn', lb);
    b = logsig('dn', ub);
    g = min(a,b);
    y = g.*(x - lb) + logsig(lb);
    plot(x, y, 'r');
    hold on;
    % plot tangent line at ub 
    y = g.*(x - ub) + logsig(ub);
    plot(x, y, 'r');
    hold on;
    
    y1 = g*(-lb) + logsig(lb);
    y2 = g*(-ub) + logsig(ub);
    
    g = (y2 - logsig(lb))/(0 - lb);
    y = g.*(x) + y2;
    plot(x,y,'g');
    g = (y1 - logsig(ub))/(0-ub);
    y = g.*x + y1;
    plot(x,y,'g');
    
    
%     % plot connect line between lb and ub
%     a = (logsig(ub) - logsig(lb))/(ub - lb);
%     y = a.*(x-lb) + logsig(lb);
%     plot(x,y, 'r');
%     hold on;
%     
%     % plot tangent line at 0
%     a = logsig('dn', 0);
%     y = a.*(x - 0) + logsig(0);
%     plot(x, y, 'g');
      
    
end


end