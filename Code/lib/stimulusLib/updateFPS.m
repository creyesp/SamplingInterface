function fps = updateFPS(fpsconfigurate, fpsreal)

    rate = round(fpsreal/fpsconfigurate);
    if round < 1,
        fps = fpsreal;
    else
        fps = rate*fpsreal;
    end
end