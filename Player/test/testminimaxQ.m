clear all;
close all;
clc;
addpath('../');
m = minimaxQPlayer(1,2,2,1e-4,0.2,0.9);
m.Q(:,:,1) = [0,1;1,0.5];
m.UpdateV(1);
disp(m.Pi);
disp(m.V);
