%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：7-3_PI_Control.m
%% 程序功能：比例积分控制
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 程序初始化，清空工作空间，缓存，
clear all;
close all;
clc;
% 读取Octave控制和信号数据库（注：如使用Matlab，可删除或注释掉本行代码）
pkg load control
%% 定义传递函数
G_s = tf([1], [1,1]);
%% 定义不同积分增益控制器
C_s_1 = tf([1],[1 0]);
C_s_2 = tf([2],[1 0]);
C_s_3 = tf([3],[1 0]);
%% 定义闭环传递函数
Gcl_1 = feedback (C_s_1*G_s, 1);
Gcl_2 = feedback (C_s_2*G_s, 1);
Gcl_3 = feedback (C_s_3*G_s, 1);
%% 定义仿真时间
t = [0:0.1:10];
%% 绘图
x1 = step (Gcl_1,t);
x2 = step (Gcl_2,t);
x3 = step (Gcl_3,t);
plot (t,x1);
hold on;
plot (t,x2);
plot (t,x3);
grid on;
xlim([0 10]);
ylim([0 1.5]);
legend ('Ki=1', 'Ki=2', 'Ki=3');
