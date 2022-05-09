function [setup] = defaultArraySetup(setup, RIRconstants)
setup.array.micOffset=RIRconstants.micOffset;
setup.array.micNumber=RIRconstants.AmountOfMicrophones;
setup.array.micSpacing=360/setup.array.micNumber;
setup.array.micAngles=setup.array.micOffset...
    +setup.array.micSpacing*(0:(setup.array.micNumber-1))';
setup.array.micRadius = RIRconstants.micRadius;
setup.array.rotorRadius = RIRconstants.micRadius;
setup.array.micPos=setup.array.micRadius...
    *[cosd(setup.array.micAngles),sind(setup.array.micAngles)];

setup.array.rotorOffset=RIRconstants.micOffset;
setup.array.rotorNumber = RIRconstants.AmountOfMicrophones;
setup.array.rotorSpacing=360/setup.array.rotorNumber;
setup.array.rotorAngles = setup.array.rotorOffset...
    +setup.array.rotorSpacing*(0:(setup.array.rotorNumber-1))';
setup.array.rotorPos=setup.array.rotorRadius...
    *[cosd(setup.array.rotorAngles),sind(setup.array.rotorAngles)];
end

