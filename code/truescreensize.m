function [screensize] = truescreensize()


% function that detects the true screen resolution of the screen Matlab is
% running on, based on java rather tahn Matlab's get(0,'ScreenSize') which
% seems to go haywire on multiple screen setups.

ge = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment;
gd = ge.getDefaultScreenDevice;
screensize = [gd.getDisplayMode.getWidth gd.getDisplayMode.getHeight];