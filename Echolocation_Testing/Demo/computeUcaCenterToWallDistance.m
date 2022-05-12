function estimates=computeUcaCenterToWallDistance(setup,estimates)
    estimates.emUca.distance=estimates.emUca.toa/setup.signal.sampFreq*setup.room.soundSpeed/2 ...
        +(cosd(setup.array.micOffset-estimates.emUca.angle))*setup.array.micRadius;
    
    tempPosEm=[estimates.emUca.distance.*cosd(estimates.emUca.angle),...
        estimates.emUca.distance.*sind(estimates.emUca.angle)];
    estimates.emUca.wallPos=ones(setup.EM.nRefl,1)*setup.room.sourcePos(:,1:2)...
        +tempPosEm;
    
    %estimates.mpdrUca.distance=estimates.toaNlsMpdr/setup.signal.sampFreq*setup.room.soundSpeed/2 ...
    %    +(cosd(setup.array.micOffset-estimates.doaNlsMpdr))*setup.array.micRadius;
    
    %tempPosMpdr=[estimates.mpdrUca.distance.*cosd(estimates.doaNlsMpdr),...
    %    estimates.mpdrUca.distance.*sind(estimates.doaNlsMpdr)];
    %estimates.mpdrUca.wallPos=ones(setup.EM.nRefl,1)*setup.room.sourcePos(:,1:2)...
    %    +tempPosMpdr;
end

