clc;clear; close all;
addpath(genpath('lib'));
addpath(genpath('data'));
%%% SOUND-BASED ECHOLOCATION FOR MOBILE ROBOTIC PLATFORMS %%%
% This script serves as a demonstration of one of our recent methods 
% for echolocation using a robotic platform. Echolocation is a biologically 
% inspired technique for estimating the location of a vehicle in relation
% to a number of objects. This is done by emitting a known signal into the 
% environment, and listening for echoes of the signals. The delay of the 
% echoes then carry information about the distance to the objects 
% reflecting the known signal. In nature, this technique is used by animals 
% such as bats, rats, dolphins, etc. 

% The method is submitted for publication in:
% J. R. Jensen, U. Saqib, and S. Gannot, "An EM Method for Multichannel
% TOA and DOA Estimation of Acoustic Echoes", in Proc. IEEE Workshop
% Applications Signal Process. Audio Acoustics, 2019.

% In my current project, we're mimicking this ability using audible sound 
% and advanced signal processing. A hardware setup using a number of 
% microphones and a loudspeaker is used. This is depicted in Figure 1. 

%% SETUP AND PLOT ROOM
% setup parameters
setup=defaultMiscSetup([]);
setup=defaultSignalSetup1(setup);
setup=defaultArraySetup(setup);
setup=defaultRirGenSetup(setup);
setup=defaultRoomSetup(setup);
setup=defaultEmSetup(setup);

setup.EM.noiseWeighting=1;

setup.EM.plotIterations=1; 
setup.EM.directPathFlag=0;
setup.signal.snr=[40 40 40 -40];
setup.signal.sdnr=80;
setup.EM.maximumDistance=2;
setup.EM.nRefl=3;
setup.EM.nIter=20;
setup.room.dimensions=[6,4,3];
setup.room.sourcePos=[4.8,2.9,1];
for kk=1:setup.array.micNumber
    setup.room.receivPos(kk,:)=[...
        setup.room.sourcePos(1:2)+setup.array.micPos(kk,:),...
        setup.room.sourcePos(3)-setup.room.distSourceToReceiv];
end

plotRoom(setup);

% In this demo, a so-called room impulse response generator is then used
% to generate the multichannel signals. This enable us to experiment with
% different geometries in an efficient way.

%% GENERATE AND PLOT RIRS 
% generate rirs
rirs=generateRirs(setup);
% plotRIRs(rirs);

% The signals involved in the considered method are:
%   - Probe signal: White Gaussian noise burst
%   - Noise signal: Diffuese rotor noise from drone 
%       + white Gaussian sensor noise

%% GENERATE AND PLOT SIGNALS
% generate signals
signals=generateSignals(rirs,[],setup);
plotSignals(signals);

%% PLAY SIGNALS
soundsc(signals.clean,setup.signal.sampFreq);
%%
soundsc(signals.reflec(:,1),setup.signal.sampFreq);
%%
soundsc(signals.noise(:,1)+signals.diffNoise(:,1),setup.signal.sampFreq);
%%
soundsc(signals.observRefl(:,1),setup.signal.sampFreq);

% From the recordings of the noisy, reflected sounds obtained with each of 
% the microphones, we then wish to estimate the time-of-arrival (TOA) and
% direction-of-arrival (DOA) of each reflection. The TOA's carry
% information of the distance from the loudspeaker to the reflector (e.g.,
% walls), while the DOA carries information about the angle of the
% reflector. This can be used to map a room, e.g., to enable autonomous
% navigation with a mobile robot/drone platform. 
%
% The proposed estimator uses the expectation maximization (EM) algorithm.
% Intuitively, the idea is to 
% 1) estimate the individual reflections in the E-step using estimates of 
% the parameters of the reflections (e.g., TOA and DOA).
% 2) estimate the parameters of the individual reflections from estimated
% individual reflections (signals)
% 3) repeat step 1 and 2 until convergence. 
% The algorithm is initialized with random estimates. 

%% ESTIMATION
% uca em
[estimates,costFunction]=emCircArray(signals,setup);
toaEstimates.emUca(:,1)=estimates.emUca.toa;

%% PLOT TIME-OF-ARRIVAL ESTIMATES
plotRIRs(rirs,estimates);

%% CALCULATE AND PLOT WALLPOSITION ESTIMATES
estimates=computeUcaCenterToWallDistance(setup,estimates);

plotRoom(setup,estimates);

%% FUNCTIONS

% function for plotting the room
function plotRoom(setup,estimates)
    h99=figure(99);
    plot([0,setup.room.dimensions(1)],[0,0],'k-','LineWidth',1);
    hold on;
    plot(NaN,NaN,'bo','LineWidth',1);
    plot(NaN,NaN,'rx','LineWidth',1);
    plot(NaN,NaN,'g.','LineWidth',1,'MarkerSize',10);
    plot([0,setup.room.dimensions(1)],[setup.room.dimensions(2),setup.room.dimensions(2)],'k-','LineWidth',1);
    plot([setup.room.dimensions(1),setup.room.dimensions(1)],[0,setup.room.dimensions(2)],'k-','LineWidth',1);
    plot([0,0],[0,setup.room.dimensions(2)],'k-','LineWidth',1);
    plot(setup.room.receivPos(:,1),setup.room.receivPos(:,2),'bo');
    plot(setup.room.sourcePos(:,1),setup.room.sourcePos(:,2),'rx');
    hold off;    
    if nargin>1
        hold on;
        plot(estimates.emUca.wallPos(:,1),estimates.emUca.wallPos(:,2),'g.','LineWidth',1,'MarkerSize',10);
        hold off;
    end
    xlim([-1 setup.room.dimensions(1)+1]);
    ylim([-1 setup.room.dimensions(2)+1]);
    grid on;
    title('Figure 1: Experimental setup');
    h99.Position=[3 43 665 512];
    xlabel('x [m]');
    ylabel('y [m]');
    if nargin>1
        legend('Walls','Mic.','Spkr.','Wall est.','Orientation','Horizontal','Location','NorthWest');
    else
        legend('Walls','Mic.','Spkr.','Orientation','Horizontal','Location','NorthWest');
    end
    drawnow;
end

% function for plotting the RIRs
function plotRIRs(rirs,estimates)
    h98=figure(98);
    h98.Position=[852 137.5000 514.5000 698];
    text(0,0,'test');
    subplot(3,1,1);
    plot(0:(length(rirs.reflec(1,:))-1),rirs.reflec(1,:)');
    if nargin>1
        hold on;
        plot([estimates.emUca.toa,estimates.emUca.toa]',...
            (ones(length(estimates.emUca.toa),1)*[0,max(rirs.reflec(1,:))])','r--','LineWidth',1);
        hold off;
    end    
    xlim([0,500]);
    title('Loudspeaker to mic. 1');
    xlabel('Time [samples]');
    ylabel('h_1[t]');
    grid on;
    if nargin>1
        legend('RIR','Est. TOAs');
    else 
        legend('RIR');
    end
    subplot(3,1,2);
    plot(0:(length(rirs.reflec(2,:))-1),rirs.reflec(2,:)');
    xlim([0,500]);
    title('Loudspeaker to mic. 2');
    xlabel('Time [samples]');
    ylabel('h_2[t]');
    grid on;
    legend('RIR');
    subplot(3,1,3);
    plot(0:(length(rirs.reflec(3,:))-1),rirs.reflec(3,:)');
    xlim([0,500]);
    title('Loudspeaker to mic. 3');
    xlabel('Time [samples]');
    ylabel('h_3[t]');
    grid on;
    legend('RIR');
    sgtitle('Figure 2: Room Impulse Response from Speaker to Mics');
    drawnow;
end

% function for plotting signals
function plotSignals(signals)
    h97=figure(97);
    h97.Position=[267 88 542.5000 745];
    subplot(4,1,1);
    plot(0:length(signals.clean)-1,signals.clean);
    xlabel('Time [samples]');
    title('Clean probe sound');
    grid on;
    subplot(4,1,2);
    plot(0:length(signals.clean)-1,signals.reflec(:,1));
    xlabel('Time [samples]');
    title('Reflected probe sound');
    grid on;
    subplot(4,1,3);
    plot(0:length(signals.clean)-1,signals.noise(:,1)+signals.diffNoise(:,1));
    xlabel('Time [samples]');
    title('Noise (diffuse+sensor)');
    grid on;
    subplot(4,1,4);
    h97p4=plot(0:length(signals.clean)-1,signals.observRefl(:,1));
    xlabel('Time [samples]');
    title('Observation (reflected probe sound + noise)');
    grid on;
    sgtitle('Figure 3: Plots of signals');
    drawnow;
end