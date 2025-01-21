%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：9-1_Bodeplot_Examples.m
%% 程序功能：伯德图举例
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 程序初始化，清空工作空间，缓存，
clear all;
close all;
clc;
% 读取Octave控制数据库（注：如使用Matlab，可删除或注释掉本行代码）
pkg load control;
%
%%例子1
%%一阶系统 Gs = 1/(1/5s+1)
figure(1, 'position',[200 200 800 600]);
sys = tf ([1],[1/5 1]);
bode(sys)
%%
%%比例控制 Cs = 2
figure(2, 'position',[200 200 400 600]);
sys = pidstd(2)
bode(sys)

%%比例控制 Cs = 0.5
figure(3, 'position',[200 200 400 600]);
sys = pidstd(0.5)
bode(sys)
%%
%% 积分控制 Cs = 1/0.5s
figure(4, 'position',[200 200 800 600]);
sys = tf([1],[0.5 0]);
bode(sys)
%
%%% 比例积分控制 Cs = 1*(1+1/s)
figure(5, 'position',[200 200 800 600]);
sys = pidstd(1,1,0)
bode(sys)
%
%%比例微分控制 Cs = 1*(1+0.2s)
figure(6, 'position',[200 200 800 600]);
sys = pidstd(1,inf,0.2)
bode(sys)
%
%%比例积分微分控制 Cs = 1*(1+1/s+0.1s)
figure(7, 'position',[200 200 800 600]);
sys = pidstd(1,1,0.1)
bode(sys)
%
%%超前补偿器 Cs = (s+1)*(s+10)
figure(8, 'position',[200 200 800 600]);
sys = tf([1 1],[1 10]);
bode(sys)

%%滞后补偿器 Cs = (.1s+1)*(s+1)
figure(9, 'position',[200 200 800 600]);
sys = tf([.1 1],[1 1]);
bode(sys)
