%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：9-4_Rlocus_GM.m
%% 程序功能：根轨迹与幅值裕度
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
%% 定义控制器
Cs1 = pid (0, 1 , 0);
Cs2 = pid (1 ,1 , 0);
%% 绘制根轨迹
figure(1, 'position',[200 100 1400 400]);
subplot(1,3,1);
rlocus(Gs);
legend off;
grid off;
subplot(1,3,2);
rlocus(Cs1*Gs);
legend off;
grid off;
subplot(1,3,3);
rlocus(Cs2*Gs);
legend off;
grid off;

