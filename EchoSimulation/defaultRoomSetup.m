function [setup] = defaultRoomSetup(setup, roomConstants)
setup.room.dimensions=[roomConstants.length,roomConstants.width,roomConstants.height];
setup.room.T60=0.6;
setup.room.soundSpeed=343;
setup.room.distSourceToReceiv=0;
Dest=setup.room.distSourceToReceiv/setup.room.soundSpeed...
    *setup.signal.sampFreq;
setup.room.distToWall=1;
setup.room.sourcePos=[roomConstants.po,position(2),position(3)];

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

