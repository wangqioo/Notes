%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：10-4_Tracking_Problem.m
%% 程序功能：轨迹追踪
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
tspan = [0: 0.1: 40];
% 状态初始化
z0=[0;0];
%%%%%%%%%%%%%%%%%定义系统微分方程%%%%%%%%%%%%%%%%%%%%%
function  dz = Tracking_sys(t,z,A,B,C,D,g,d)
%%%%%%%%%%%%%%%%%输入定义%%%%%%%%%%%%%%%%%%%%%
% 定义区间目标
if t >= 0 && t <10
   zd = [pi/20;0];
   elseif t >= 20 && t <30
   zd = [-pi/20;0];
   else
   zd = [0;0];
end
 % 定义误差控制矩阵
 Ke = [25, 7];
 % 定义前馈
 F = [-g/d, 0];
 % 定义误差
 e = zd - z;
 % 定义控制器
 u = F * zd + Ke*e;
 % 定义状态空间方程
 dz = A*z + B*u;
end
% 使用 ode45 求解微分方程
[t, z] = ode45(@(t,z)Tracking_sys(t,z,A,B,C,D,g,d), tspan, z0);
% 使用传递函数，pid控制器
% 定义系统传递函数
G_s = tf([1], [1,0,-g/d]);
% 定义控制器
C_s = pid (50,8,10);
% 定义反馈系统
sys_cl = feedback(G_s*C_s,1);
% 定义区间目标
% 初始化目标r
r = zeros(size(tspan));
% 定义r在个区间目标
for i = 1:length(tspan)
    t = tspan(i);
    if t >= 0 && t < 10
        r(i) = pi/20;
    elseif t >= 20 && t < 30
        r(i) = -pi/20;
    else
        r(i) = 0;
    end
end
% 线性仿真
x = lsim(sys_cl,r,tspan);
%%%%%%%%%%%%%%%%%结果%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1, 'position',[200 100 600 300]);
% 状态变量结果图
% 系统状态z1结果图
plot(tspan,z(:,1),"linewidth",1);
hold on;
plot(tspan,r,"--","linewidth",1);
plot(tspan,x,"linewidth",1);
grid on;




