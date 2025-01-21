%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：9-3_GM_PM_Controller_Design.m
%% 程序功能：基于裕度分析的控制器设计
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 程序初始化，清空工作空间，缓存，
clear all;
close all;
clc;
% 读取Octave控制数据库（注：如使用Matlab，可删除或注释掉本行代码）
pkg load control
% 定义系统模型
% 定义系统传递函数
s = tf('s');
Gs = tf([1],[1 1.6 1]);
% 定义反馈传递函数，尝试Hs=1 和 Hs=1/s+1两种，请注释其中一个
Hs = 1;
% Hs = 1/(s+1);
% 定义控制器，请尝试不同控制器
Cs = pid(1, 1 , 0);
% 定义开环系统
sys = Cs*Gs*Hs;
% 绘制Nyquist图
figure(1, 'position',[200 200 600 600]);
[re, im, w]= nyquist(sys);
plot(re(:), im(:), 'k');
grid on;
% 绘制伯德图
figure(2, 'position',[200 200 600 600]);
bode(sys)
% 绘制回馈系统的单位阶跃响应
figure(3, 'position',[200 200 600 400]);
step(feedback(Cs*Gs,Hs))
% 计算裕度
[Gm, phi, w_gamma, w_phi] = margin (sys)
Gm_dB = 20*log10(Gm)
