function [setup] = defaultRoomSetup(setup, RIRconstants)
setup.room.dimensions=[RIRconstants.roomLength,RIRconstants.roomWidth,RIRconstants.roomHeight];
setup.room.T60=0.6;
setup.room.soundSpeed=RIRconstants.SpeedofSound;
setup.room.distSourceToReceiv=0;
Dest=setup.room.distSourceToReceiv/setup.room.soundSpeed...
    *setup.signal.sampFreq;
setup.room.distToWall=1;
setup.room.sourcePos=[RIRconstants.robotPos(1),RIRconstants.robotPos(2),RIRconstants.robotPos(3)];

for kk=1:setup.array.micNumber
    setup.room.receivPos(kk,:)=[...
        setup.room.sourcePos(1:2)+setup.array.micPos(kk,:),...
        setup.room.sourcePos(3)-setup.room.distSourceToReceiv];
end

for kk=1:setup.array.rotorNumber
    setup.room.rotorPos(kk,:)=[...
        setup.room.sourcePos(1:2) + setup.array.rotorPos(kk,:),...
        setup.room.sourcePos(3)-setup.room.distSourceToReceiv+0.1];
end
end

