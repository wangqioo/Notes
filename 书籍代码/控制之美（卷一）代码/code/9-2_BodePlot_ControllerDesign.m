%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：9-2_BodePlot_Controller_Design.m
%% 程序功能：基于伯德图的控制器设计
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 程序初始化，清空工作空间，缓存，
clear all;
close all;
clc;
% 读取Octave控制和信号数据库（注：如使用Matlab，可删除或注释掉本行代码）
pkg load control
% 定义系统传递函数
Gs = tf([5] ,[1 5]);
% 定义控制器，请读者根据案例更改参数并进行分析
Cs = pid(0,1);
% 构建闭环系统传递函数
sys = Cs * Gs;
% 构建补偿敏感度传递函数
Ts = feedback(Cs*Gs,1);
% 构建敏感度传递函数
Ss =1/(1+Cs * Gs);
% 生成仿真信号
t = 0 : 0.01 : 50;
% 定义参考
r = ones(size(t));
% 生成干扰信号，读者可更改其中参数进行分析
disturbance = 0.5 * sin(0.1 * t);
% 生成噪声信号，读者可更改其中参数进行分析
noise = 0.2 * sin( 100 * t);
% 仿真系统响应
% 参考信号与噪声的合成输入
x1 = lsim(Ts, r - noise, t);
% 干扰信号的系统响应
x2 = lsim(Ss, disturbance, t);
% 绘制扰动和噪声
figure(1, 'position',[200 200 1600 300]);
subplot(1,2,1);
title('Disturbance');
plot(t, disturbance);
ylim ([-0.6, 0.6]);
grid on;
subplot(1,2,2);
title('noise');
plot(t, noise);
ylim ([-0.6, 0.6]);
grid on;
% 绘制系统伯德图
figure(2, 'position',[100 200 600 600]);
bode(Gs,{0.01, 100})
figure(3, 'position',[700 200 600 600]);
bode(Cs,{0.01, 100})
figure(4, 'position',[1300 200 600 600]);
bode(Cs*Gs,{0.01, 100})
% 绘制仿真结果
figure(5, 'position',[200 200 1200 600]);
plot(t, x1 + x2,"linewidth",1);
hold on
plot(t,ones(size(t)),"linewidth",1, 'LineStyle', '--')
ylim([0, 1.25]);
grid on;



