function [safe,t] = check_safe(net,S,U,method)
    safe = 2;
    vt=tic;
    [R,~]=net.reach(S,method,4);
    for i=1:9
%         for j = 1:size(R,2)
              if isempty(R.intersectHalfSpace(U(i,:), 0))%(:,j)(i,j) for exact star
                  safe = 1;
                    %fprintf('Safe:  %d',safe);
              else
                  safe = 2; %2 for approx-star)
                    %fprintf('Safe:  %d',safe);
                  break
              end
%         end
    end
    t=toc(vt);
%     poolobj = gcp('nocreate');
% 	delete(poolobj);
    fprintf('Time:  %d',t);
end