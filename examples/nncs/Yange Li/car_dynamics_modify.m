function [dx]=car_dynamics_modify(t, x, vr)

% x1 = lead_car position
% x2 = lead_car velocity
% x3 = lead_car internal state

% x4 = ego_car position
% x5 = ego_car velocity
% x6 = ego_car internal state

Lr = 2;
Lf = 2;

% lead car dynamics
% if vr > 100
%     vr = 100;
% elseif vr < -0
%     vr = -0;
% end
% 
% if delta > np.pi/3 
%     delta = np.pi/3;
% elseif delta < -np.pi/3
%     delta = -np.pi/3;
% end

% beta = atan(Lr/(Lr+Lf) * sin(vr(2))/cos(vr(2)));

dx(1,1) = vr(1) * cos(x(3)+vr(2));                      % x
dx(2,1) = vr(1) * sin(x(3)+vr(2));                      % y
dx(3,1) = vr(1)/4*sin(vr(2));                                    % theta
dx(4,1) = 0;                                        % x_ref
dx(5,1) = 0;                                        % y_ref
dx(6,1) = 0;                                        % theta_ref
dx(7,1) = -sin(x(6) - x(3))*(0- vr(1)/4*sin(vr(2)));  % error_theta_cos
dx(8,1) = cos(x(6) - x(3))*(0- vr(1)/4*sin(vr(2)));   % error_theta_sin
end