function [setup] = defaultEmSetup(setup, RIRconstants)
setup.EM.plotIterations=0;
% setup.EM.minimumDistance=setup.array.micRadius+0.1;
setup.EM.minimumDistance=RIRconstants.minimumDistance;
setup.EM.maximumDistance=RIRconstants.maximumDistance;
setup.EM.nRefl=1;
setup.EM.nIter=30;
setup.EM.beta=1/setup.EM.nRefl;
setup.EM.directPathFlag=RIRconstants.directPathFlag;
end

