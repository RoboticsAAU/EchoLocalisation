function cleanUpFunction(cmdout)
% Kills the minimal.launch ros node.
    system("kill " + string(cmdout));
end

