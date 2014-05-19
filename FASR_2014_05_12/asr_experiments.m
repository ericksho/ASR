% FASR: Face Recognition by Adaptive Sparse Representations
% =========================================================
%
% asr_experiments.m : Experiments 
%
% see also asr_experimentspar.m for an implementation that uses the Toolbox
% of parallel computing.
%
% NOTE: please change in asr_defoptions.m the variable opdef.local_data
% in order to indicate the location of your data.
%
% Example:
% options.stoplist=0;T = asr_experiments([2 4 7],[1 3],100,options);
% It executes 100 times algorithms 1 and 3 (asr and src) on the databases
% 2, 4 and 7 (yale, rr, lfwf) using default values but without stoplist
%
% options.NV=350;T = asr_experiments(1,1,50,options);
% It executes 50 times algorithm 1 (asr) on databases 1 (orl)
% using default values, i.e. with stoplist but with a dictionary of 350 
% words. 
%
% Databases:
%  1     2      3     4    5    6     7      8          9           10          11
% 'orl','yale','cas','rr','ar','ar+','lfwf','multiPIE','bxgrid_01','bxgrid_02','bxgrid_03'
%
% Face recognition programs:
%  1          2          3          4          5
% 'asr_main','int_main','src_main','tpt_main','lbp_main'
%
%
% (c) Domingo Mery - PUC (2013), ND (2014)

function T = asr_experiments(test_sets,test_prgs,N,options)

% reading names of databases and programs

x     = asr_defoptions;
dbase = x.dbase; % 'orl','yale','cas','rr','ar','ar+','lfwf','multiPIE','bxgrid_01','bxgrid_02','bxgrid_03'
pbase = x.pbase; % 'asr_main','int_main','src_main','tpt_main','lbp_main'

nt    = length(test_sets);
np    = length(test_prgs);
acc   = zeros(N,nt,np);
for i=1:N
    T = zeros(nt,np);
    for j = 1:nt
        stbase = dbase{test_sets(j)};
        for k = 1:np
            prg = pbase{test_prgs(k)};
            % acc(i,j,k) = feval(prg,stbase,options);
            acc(i,j,k) = asr_main(stbase,options);
            x = mean(acc(1:i,j,k))*100;
            T(j,k) = x;
            fprintf('%3d) %10s/%10s = %6.2f%% \n',i,prg,stbase,mean(x(:)));
        end
    end
    fprintf('\n\nAverage with N=%d:\n',i)
    fprintf('             ');
    for k=1:np
        ps = pbase{test_prgs(k)};
        fprintf('  %s   ',ps(1:3));
    end
    fprintf('\n');
    for j=1:nt
        fprintf('%10s ',dbase{test_sets(j)});
        [~,jj] = max(T(j,:));
        for k=1:np
            % x = mean(acc(1:i,j,k))*100;
            fprintf(' %6.2f',T(j,k));
            if k==jj
                fprintf('*');
            else
                fprintf(' ');
            end
        end
        fprintf('\n');
    end
    
    Tm = mean(T,1);
    fprintf('   Total-> ');
    [~,jj] = max(Tm);
    for k=1:np
        % x = mean(acc(1:i,j,k))*100;
        fprintf(' %6.2f',Tm(k));
        if k==jj
            fprintf('*');
        else
            fprintf(' ');
        end
    end
    fprintf('\n');
    
    
end
