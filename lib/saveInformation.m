function saveInformation( name, handles )
%SAVEINFORMATION Summary of this function goes here
%   Detailed explanation goes here

inf.mode = handles.mode;
inf.experiments = handles.experiments;        
inf.list = handles.list;
inf.img = handles.img;
inf.bottomBar = handles.bottomBar;
inf.beforeStimulus = handles.beforeStimulus;
inf.modify = handles.modify;
inf.screens = handles.screens;
inf.time = handles.time;

inf.presentation = handles.presentation;
inf.flicker = handles.flicker;
inf.whitenoise = handles.whitenoise;
inf.onlyStimulus = handles.onlyStimulus;
inf.maskStimulus = handles.maskStimulus;
save(name,'-struct','inf');

end

