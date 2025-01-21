%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：5-1_2nd_Order_Step_Response.m
%% 程序功能：二阶系统单位阶跃响应，ζ效应
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 程序初始化，清空工作空间，缓存，
clear all;
close all;
clc;
% 读取Octave控制和信号数据库（注：如使用Matlab，可删除或注释掉本行代码）
pkg load control

%% 定义不同zeta
zeta = [0, 0.2, 0.5, 1, 2];
%% 定义固有频率
w_n = 10;
%% 设置仿真时间
t = 0:0.01:1.5;
%% 设置显示颜色
colorcode = ['r', 'b', 'g', 'k', 'y'];
%% 运行系统在不同zeta下的表现并绘图
for i =1:length(zeta)
  hold on;
  G = tf([w_n^2],[1,2*w_n*zeta(i),w_n^2]);
  step(G,t,colorcode(i));
end
legend ('zeta = 0', 'zeta = 0.2',
'zeta = 0.5','zeta = 1','zeta = 2');
