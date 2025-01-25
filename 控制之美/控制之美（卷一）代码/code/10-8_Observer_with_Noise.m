%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：10-8_Observer_with_Noise.m
%% 程序功能：观测器的滤波器性质
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 程序初始化，清空工作空间，缓存，
clear all;
close all;
clc;
% 读取Octave控制数据库（注：如使用Matlab，可删除或注释掉本行代码）
pkg load control
%%%%%%%%%%%%%%%%%系统定义%%%%%%%%%%%%%%%%%%%%%
 % 定义系统矩阵A
   A=[0 1;-1 -0.5];
% 定义输入矩阵B
  B=[0;1];
% 定义输出矩阵C
 C = [1, 0];
% 定义直接输入矩阵D
 D = 0;
% 定义仿真时间
 tspan = [0:0.01:20];
% 全阶观测器状态初始化
 z0=[1;1;0;0];
% 输入初始化
 u0 = 0;
 u = 0;
 %%%%%%%%%%%%%%%%%定义全阶观测器系统微分方程%%%%%%%%%%%%%%%%%%%%%
 function  dz = sys_Full(t, z, A, B, C, D, u0)
  %% 定义恒定输入u=0
  u = u0;
  %% 定义真实值Z1，Z2的状态空间方程
  dz_real=A*z(1:2)+B*u;
  %% 定义输出的状态空间方程，增加高频噪声
  y=C*z(1:2)+D*u + 0.1 * sin( pi * 20 * t);
  %% 定义观测矩阵
  L=[1.5; -0.75];
  %% 定义观测器的状态空间方程
  dz_hat=(A-L*C)*z(3:4)+B*u+L*y;
  %% 定义ode45求解的向量z
  %% z向量一共有4列，第一列为z1真实值，第二列为z2真实值，第3列为z1估计值，第4列为z2估计值，
  dz = [dz_real;dz_hat];
 end
% 求解全阶观测器系统
[t_full,z_full]= ode45(@(t, z)sys_Full(t, z, A, B, C, D, u0),tspan,z0);


% 降阶观测器状态初始化
z0=[1;1;0];
L= 0.5;
 %%%%%%%%%%%%%%%%%定义降阶观测器系统微分方程%%%%%%%%%%%%%%%%%%%%%
 function  dz = sys_RO(t, z, A, B, C, D, L, u0)
  %% 定义恒定输入u=0
  u = u0;
  %% 定义真实值Z1，Z2的状态空间方程
  dz_real=A*z(1:2)+B*u;
  %% 定义输出的状态空间方程
  y=C*z(1:2)+D*u+0.1 * sin( pi * 20 * t);
  %% 定义观测器的状态空间方程，增加高频噪声
  dz_bar = -z(3)-1.5*y;
  %% 定义ode45求解的向量z
  %% z向量一共有3列，第一列为z1真实值，第二列为z2真实值，第3列为z2估计值
  dz = [dz_real;dz_bar];
 end
% 求解降阶观测器系统
[t_reduce,z_reduce]=ode45(@(t,z)sys_RO(t, z, A, B, C, D, L, u0),tspan,z0);
% 使用式（10.4.32）计算观测值
z1_hat_reduce = z_reduce(:,1)+0.1 * sin(2 * pi * 20 * t_reduce);
z2_hat_reduce = z_reduce(:,3)+0.5*z1_hat_reduce;

% 绘图
%% 全阶观测器
% z1 与 z1 hat比较
figure(1, 'position',[200 100 600 300]);
plot (t_full,z_full(:,1));
hold on;
plot (t_full,z_full(:,3),"--");
legend("z1","z1 hat");
hold off;
grid on;
% z2 与 z2 hat比较
figure(2, 'position',[200 100 600 300]);
plot (t_full,z_full(:,2));
hold on;
plot (t_full,z_full(:,4),"--");
legend("z2","z2 hat");
hold off;
grid on;

%% 降阶观测器
% z1 与 z1 hat比较
figure(3, 'position',[200 100 600 300]);
plot (t_reduce,z_reduce(:,1));
hold on;
plot (t_reduce,z1_hat_reduce,"--");
legend("z1","z1 hat");
hold off;
grid on;
% z2 与 z2 hat比较
figure(4, 'position',[200 100 600 300]);
plot (t_reduce,z_reduce(:,2));
hold on;
plot (t_reduce,z2_hat_reduce,"--");
legend("z2","z2 hat");
hold off;
grid on;


