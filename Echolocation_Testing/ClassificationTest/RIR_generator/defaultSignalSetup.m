function [setup] = defaultSignalSetup(setup, RIRconstants)
setup.signal.lengthBurst=RIRconstants.lengthBurst;
setup.signal.lengthSignal=RIRconstants.lengthSignal;
setup.signal.snr=RIRconstants.signalSNR;
setup.signal.sdnr=RIRconstants.signalSDNR;
setup.signal.sampFreq=RIRconstants.sampFreq;
setup.signal.diffNoiseStr='allMotors_70_mic1.wav';
end

