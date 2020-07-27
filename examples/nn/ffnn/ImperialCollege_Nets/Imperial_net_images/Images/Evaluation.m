%load('labels.mat');
load('net256x6.mat');
% for i=1:50
%     file='image'+string(i);
%     im=dlmread(file);
%     im=im(1:784)/255;
%     [~,pred(i)]= max(net.evaluate(im'));
% end
%net2_im_safe_time=zeros([25,2]);
% load('net22_im_safe_time.mat');
% net3_im_safe_time=net3_im_safe_time;
for i=1:2
    if  i>0%net1_im_safe_time(i,1)==2
        file='image'+string(i);
        im=dlmread(file);
        im=im(1:784)/255;
        ep=0.02;

        lb=im'-ep;
        ub=im'+ep;

        lb(lb>1)=1;
        lb(lb<0)=0;
        ub(ub>1)=1;
        ub(ub<0)=0;

        S=Star(lb,ub);
        U=create_unsafe_matrices(labels(i));
        [safe,t] = check_safe(net,S,U,'approx-star');
        net22_im_safe_time(i,1)=safe;
        net22_im_safe_time(i,2)=t;
%         save net22_im_safe_time.mat net22_im_safe_time;
%         t_out=900;
% %         pool = parpool('local',4);
%         f(1) = parfeval(@check_safe,2,net,S,U,'approx-star');%pool,
%         vt = tic;
%         [idx,safe,~] = fetchNext(f,t_out);
%         t=toc(vt);
%         if isempty(safe)
%             net1_im_safe_time(i,1)=3;
%             net1_im_safe_time(i,2)=t_out;
%             save net1_im_safe_time.mat net1_im_safe_time;
%         else
%             net1_im_safe_time(i,1)=safe;
%             net1_im_safe_time(i,2)=t;
%             save net1_im_safe_time.mat net1_im_safe_time;
%         end
        fprintf('image: ========================================================%d %f %d\n',i,t,safe);
    end
%     poolobj = gcp('nocreate');
% 	delete(poolobj);
end 
% sum(net1_im_safe_time(:,1)==1)