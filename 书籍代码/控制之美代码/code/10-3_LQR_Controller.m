%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：10-3_LQR_Controller.m
%% 程序功能：LQR控制器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 程序初始化，清空工作空间，缓存，
clear all;
close all;
clc;
% 读取Octave控制数据库（注：如使用Matlab，可删除或注释掉本行代码）
pkg load control
%%%%%%%%%%%%%%%%%系统定义%%%%%%%%%%%%%%%%%%%%%
% 定义系统参数
  g=10;
  d=1;
% 定义系统矩阵A
 A=[0 1;g/d 0];
% 定义输入矩阵B
 B=[0;1];
% 定义输出矩阵C
 C = [1, 0];
% 定义直接输入矩阵D
 D = 0;
% 定义仿真时间
tspan = [0: 0.1: 10];
% 状态初始化
z0=[pi/20;0];
%%%%%%%%%%%%%%%%%定义系统微分方程%%%%%%%%%%%%%%%%%%%%%
function  dz = Closedloop_sys(t,z,A,B,C,D,K)
%%%%%%%%%%%%%%%%%输入定义%%%%%%%%%%%%%%%%%%%%%
 % 定义系统输入
 u = -K*z;
 % 定义状态空间方程
 dz = A*z + B*u;
end
% 定义传递函数
sys = ss(A,B,C,D);
% 使用lqr语句求K1
q1=[100 0;0 1];
r1=1;
[K1, z, l] = lqr (sys, q1, r1);
% 使用lqr语句求K2
q2=[1 0;0 100];
r2=1;
[K2, z, l] = lqr (sys, q2, r2);
% 使用lqr语句求K3
q3=[1 0;0 1];
r3=100;
[K3, z, l] = lqr (sys, q3, r3);
% 使用 ode45 求解微分方程
[t, z1] = ode45(@(t,z)Closedloop_sys(t,z,A,B,C,D,K1), tspan, z0);
[t, z2] = ode45(@(t,z)Closedloop_sys(t,z,A,B,C,D,K2), tspan, z0);
[t, z3] = ode45(@(t,z)Closedloop_sys(t,z,A,B,C,D,K3), tspan, z0);
% 绘图
subplot(3,1,1);
plot(t,z1(:,1));
hold on;
plot(t,z2(:,1));
hold on;
plot(t,z3(:,1));
legend('z1_1','z1_2','z1_3');
grid on;
hold off;
%% 计算z1代价
z1_1 = sum (z1(:,1).^2)
z1_2 = sum (z2(:,1).^2)
z1_3 = sum (z3(:,1).^2)
subplot(3,1,2);
plot(t,z1(:,2));
hold on;
plot(t,z2(:,2));
hold on;
plot(t,z3(:,2));
legend('z2_1','z2_2','z2_3');
grid on;
hold off;
%% 计算z2代价
z2_1 = sum (z1(:,2).^2)
z2_2 = sum (z2(:,2).^2)
z2_3 = sum (z3(:,2).^2)
subplot(3,1,3);
plot(t,-K1*z1');
hold on;
plot(t,-K2*z3');
hold on;
plot(t,-K3*z3');
legend('u_1','u_2','u_3');
grid on;
hold off;
%% 计算z3代价
u1 = sum ((-K1*z1').^2)
u2 = sum ((-K2*z2').^2)
u3 = sum ((-K3*z3').^2)
