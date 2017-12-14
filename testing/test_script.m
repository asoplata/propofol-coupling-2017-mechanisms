%{
This is a TEST script to double check that these DynaSim mechanisms work
with the current version of DynaSim.
%}

% Define equations of cell model (same for all populations)
eqns={
  'dV/dt=Iapp+@current';
};

time_end = 200; % in milliseconds
numcells = 10;

% You can program parameters just like you can anything else in MATLAB code
g_PYsyn = 0.7;

% Create DynaSim specification structure
spec=[];
spec.populations(1).name='TC';
spec.populations(1).size=numcells;
spec.populations(1).equations=eqns;
spec.populations(1).mechanism_list={'iNaChing2010TC','iKChing2010TC',...
                                 'CaBufferChing2010TC','iTChing2010TC',...
                                 'iHChing2010TC','iLeakChing2010TC',...
                                 'iKLeakChing2010TC'};
spec.populations(1).parameters={'Iapp',0,'gH',0.001};
spec.populations(2).name='RE';
spec.populations(2).size=numcells;
spec.populations(2).equations=eqns;
spec.populations(2).mechanism_list={'iNaChing2010RE','iKChing2010RE',...
                                 'iTChing2010RE','iLeakChing2010RE'};
spec.populations(2).parameters={'Iapp',0};
spec.connections(1).direction='TC->RE';
spec.connections(1).mechanism_list={'iAMPAChing2010'};
spec.connections(1).parameters={'gAMPA',0.08};
spec.connections(2).direction='RE->TC';
spec.connections(2).mechanism_list={'iGABAAChing2010','iGABABChing2010'};
spec.connections(2).parameters={'gGABAA_base',0.069,'spm',1,'tauGABAA_base',5,'gGABAB',0.001};
spec.connections(3).direction='TC->TC';
spec.connections(3).mechanism_list={'iPoissonSpiketrainCorr'};
spec.connections(3).parameters={'g_esyn',g_PYsyn,'rate',12,'T',time_end,'tau_i',10,'prob_cxn',0.5,'jitter_stddev',500};
spec.connections(4).direction='RE->RE';
spec.connections(4).mechanism_list={'iPoissonSpiketrainUncorr','iGABAAChing2010'};
spec.connections(4).parameters={'g_esyn',g_PYsyn,'rate',12,'T',time_end,'tau_i',10,'prob_cxn',0.5,'jitter_stddev',500,'gGABAA_base',0.069,'spm',1,'tauGABAA_base',5};

% "Vary" parameters, akw parameters to be varied -- run a simulation for all combinations of values
vary={
  'TC',              'gH',        [0.001];
  '(TC,RE)',         'Iapp',      [0, 0.2];
  '(RE->RE,RE->TC)', 'spm',       [1];
  '(TC->TC,RE->RE)', 'g_esyn',    [0.05];
  '(TC->TC,RE->RE)', 'prob_cxn',  [0.25];
  };


% Set simulation parameters
memlimit = '8G'; % unnecessary if running locally
% Obviously, set your own data directory
data_dir = 'test_dynasim_run';

% % Local run of the simulation, i.e. in the interactive session you're running
% % this same script in
% SimulateModel(s,'save_data_flag',1,'study_dir',data_dir,...
%               'vary',vary,'cluster_flag',0,'verbose_flag',1,...
%               'overwrite_flag',1,'tspan',[0 time_end],'solver','euler')

% Uncomment here to instead send this simulation to the cluster, and get some
%   automated plotting on the results.
dsSimulate(spec,'save_data_flag',1,'study_dir',data_dir,...
             'vary',vary,'cluster_flag',0,'verbose_flag',1,...
             'tspan',[0 time_end],'solver','euler','memory_limit',memlimit)
             
         
%              'plot_functions',{@dsPlot,@dsPlotD,@dsPlot},...
%              'plot_options',{{'plot_type','waveform','format','png'},...
%                              {'plot_type','rastergram','format','png'},...
%                              {'plot_type','power','format','png','xlim',[0 40]}});

% I usually do stuff from the command line instead of a MATLAB session, so I use
% this:

% exit
