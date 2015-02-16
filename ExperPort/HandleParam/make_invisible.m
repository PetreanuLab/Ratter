% [] = make_invisible(sph_cell)  Set 'Visible' property to 'Off' for all
%                          GUI SoloParamHandles in sph_cell.
%
% A visible GUI is one that can be seen by the user; an invisible one
% cannot. make_invisible.m has no effect on SoloParamHandles that aren't GUIs.
%
% Assumes sph_cell is a cell containing obnly SoloParamHandles.

% Written by Carlos Brody Aug 2007


function [] = make_invisible(sph_cell)

sph_cell = sph_cell(:);

for i=1:length(sph_cell),
  make_invisible(sph_cell{i});
end;

