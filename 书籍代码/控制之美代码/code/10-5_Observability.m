%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：10-5_Observability.m
%% 程序功能：可观测性判据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 程序初始化，清空工作空间，缓存，
clear all;
close all;
clc;
% 读取Octave控制和信号数据库（注：如使用Matlab，可删除或注释掉本行代码）
pkg load control
%%%%%%%%%%%%%%%%%系统定义%%%%%%%%%%%%%%%%%%%%%
% 定义状态矩阵A
A =[0 1;
    10 0];
% 定义输出矩阵
C = [1 0];
% 定义可控性矩阵
O = obsv (A,C);
% 查看可控性
if (rank(O) == size(A,1))
  disp ("The system is observable")
else
  disp ("The system is not observable")
end
