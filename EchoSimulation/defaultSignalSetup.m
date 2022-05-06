function [setup] = defaultSignalSetup(setup, signallength)
setup.signal.lengthBurst=1500;
setup.signal.lengthSignal=signallength;
setup.signal.snr=40;
setup.signal.sdnr=10;
setup.signal.sampFreq=48000 / 2;
setup.signal.diffNoiseStr='allMotors_70_mic1.wav';
end

