function [seed,name,folder]=searchForSeed(sourcePath)
[pathstr,~,~] = fileparts(sourcePath) ;
[name,folder] = uigetfile('.mat','Select seed file',[pathstr '/*.mat']);
if name ~= 0
    folder = relativepath(folder);
    s = load(fullfile(folder,name));
    if isstruct(s) && isfield(s,'s') && isfield(s.s,'Type') && isfield(s.s,'Seed') && isfield(s.s,'State')
        seed = s.s;
        rng(seed);
    else
        seed = 0;
        errordlg('File has no seed in the correct format. File must have a struct named as ''s'', which should be the seed.','Error');
    end
else
    seed = 0;
end