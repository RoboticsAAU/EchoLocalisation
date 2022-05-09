function [setup] = defaultRoomSetup(setup)
setup.room.dimensions=[6,4,3];
setup.room.T60=0.6;
setup.room.soundSpeed=343;
setup.room.distSourceToReceiv=0;
Dest=setup.room.distSourceToReceiv/setup.room.soundSpeed...
    *setup.signal.sampFreq;
setup.room.distToWall=1;
setup.room.sourcePos=[3,2.89,1];

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

