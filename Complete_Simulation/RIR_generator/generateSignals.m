function signals=generateSignals(rirs,signals,setup)
%     rng(0);
    signals.clean=[randn(setup.signal.lengthBurst,1);...
        zeros(setup.signal.lengthSignal-setup.signal.lengthBurst,1)];
%     rng('shuffle');

    signals.direct=fftfilt(rirs.direct',signals.clean);
    signals.received=fftfilt(rirs.all',signals.clean);
    signals.reflec=fftfilt(rirs.reflec',signals.clean);
%   Add sensor noise
    for kk=1:setup.array.micNumber
        if length(setup.signal.snr)==1
            signals.noise(:,kk)=sqrt(var(signals.received(:,kk))...
                /10^(setup.signal.snr/10))*randn(length(signals.received(:,kk)),1);
        else
            signals.noise(:,kk)=sqrt(var(signals.received(:,kk))...
                /10^(setup.signal.snr(kk)/10))*randn(length(signals.received(:,kk)),1);
        end
    end
    
    %% DIFFUSE NOISE
    signals.diffNoise=generateMultichanBabbleNoise(setup.signal.lengthSignal,...
        setup.array.micNumber,...
        setup.array.micPos,...
        setup.room.soundSpeed,...
        'spherical',...
        setup.signal.diffNoiseStr);
    
    for kk=1:setup.array.micNumber
        signals.diffNoise(:,kk)=sqrt(var(signals.received(:,kk))...
            /10^(setup.signal.sdnr/10))*signals.diffNoise(:,kk)...
            /sqrt(var(signals.diffNoise(:,kk)));
    end
    
    %%    
    signals.observ=signals.received+signals.noise+signals.diffNoise;
    signals.observRefl=signals.reflec+signals.noise+signals.diffNoise;
end
