README.TXT
**********

This FASR... Adaptive Sparse Represention algorithm used in face recognition problems.
    
To see a demo please use asr_experimentspar (or asr_experiments). It calls asr_main (the main program of ASR) with or without parallel computing.

In order to compare ASR with other known algorithms, the following algorithm are included:

src_main : face recognition using SRC algorithm (Wreight et al 2009)

tpt_main : face recognition using TPTSRC algorithm (Xu et al 2011)

lbp_main : face recognition using LBP features and NBNN algorithm (Boiman et al 2008)

int_main : face recognition using intensity features and NBNN algorithm (Boiman et al 2008)

% Exapmles:
%
% options.stoplist=0;T = asr_experimentspar([2 4 7],[1 3],100,options);
% It executes 100 times (using parallel computing) algorithms 1 and 3 (asr and src) 
% on the databases 2, 4 and 7 (yale, rr, lfwf) using default values but without stoplist
% > for a computer with 4 cores (or workers) the program will be executed 25 times. 
%
% options.NV=350;T = asr_experiments(1,1,50,options);
% It executes 50 times algorithm 1 (asr) on databases 1 (orl)
% using default values, i.e. with stoplist but with a dictionary of 350 
% words. 
