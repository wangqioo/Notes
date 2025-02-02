%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：8-2_Lead_Compensator.m
%% 程序功能：超前补偿器设计
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 程序初始化，清空工作空间，缓存
clear all;
close all;
clc;
% 读取Octave控制和信号数据库（注：如使用Matlab，可删除或注释掉本行代码）
pkg load control
%% 定义传递函数
s = tf('s');
G_s = 1/((s+1)*(s+3));
%% 定义开环增益
K=20;
%% 定义仿真时间
t = 0: .1: 5;
%% 绘制不含补偿器闭环系统根轨迹
subplot(2,2,1);
rlocus(G_s);
subplot(2,2,2);
%% 定义不含补偿器闭环系统
sys_1 = feedback(K*G_s, 1)
%% 绘制不含补偿器闭环系统阶跃响应
step (sys_1,t);
%%%% 引入超前补偿器
sz = -5;
sp = -10;
C_s = (s-sz)/(s-sp);
%% 绘制含补偿器闭环系统根轨迹
subplot(2,2,3);
rlocus(G_s*C_s);
%% 绘制含补偿器闭环系统阶跃响应
subplot(2,2,4);
sys_2 = feedback(K*G_s*C_s, 1)
step (sys_2,t);
