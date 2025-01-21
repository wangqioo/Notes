%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：7-2_P_Control_Weight_Loss.m
%% 程序功能：比例控制_体重模型
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 程序初始化，清空工作空间，缓存，
clear all;
close all;
clc;
% 读取Octave控制和信号数据库（注：如使用Matlab，可删除或注释掉本行代码）
pkg load control
%%%%%%%%%%%%%%%%%系统定义%%%%%%%%%%%%%%%%%%%%%
%% 定义系统变量
S = 5;
h = 175;
a = 20;
alpha = 1.3;
%% 定义初始体重
x0 = [90];
%% 定义参考目标
r = 65;
%% 建立传递函数
G_s = tf([1],[7000,10*alpha]);
%% 定义扰动量
d = -alpha*(6.25*h-5*a+S);
%% 定义三种比例控制
C_s_1 = 200;
C_s_2 = 300;
C_s_3 = 400;
%% 建立闭环系统
%% 参考值到输出的闭环传递函数
G_cl_r_1 = G_s*C_s_1/(1+G_s*C_s_1);
G_cl_r_2 = G_s*C_s_2/(1+G_s*C_s_2);
G_cl_r_3 = G_s*C_s_3/(1+G_s*C_s_3);
%% 扰动到输出的闭环传递函数
G_cl_d_1 = G_s/(1+G_s*C_s_1);
G_cl_d_2 = G_s/(1+G_s*C_s_2);
G_cl_d_3 = G_s/(1+G_s*C_s_3);
%% 定义仿真时间
t = 0:1:200;
%% 仿真结果，三个输出
%% 结果为三部分的叠加
x1 = r*step(G_cl_r_1,t) + d*step(G_cl_d_1,t) + 7000*x0*impulse(G_cl_d_1,t);
x2 = r*step(G_cl_r_2,t) + d*step(G_cl_d_2,t) + 7000*x0*impulse(G_cl_d_2,t);
x3 = r*step(G_cl_r_3,t) + d*step(G_cl_d_3,t) + 7000*x0*impulse(G_cl_d_3,t);
%% 定义误差
e1 = r  - x1 ;
e2 = r  - x2 ;
e3 = r  - x3 ;
%% 计算系统控制量
u1 = C_s_1* e1;
u2 = C_s_2* e2;
u3 = C_s_3* e3;
%% 绘图
%% 输出与时间关系
figure(1, 'position',[200 100 700 400]);
plot (t,x1,"linewidth",1);
hold on;
plot (t,x2,"linewidth",1);
plot (t,x3,"linewidth",1);
plot (r*ones(size(t)),'--',"linewidth",1);
xlim ([0 200]);
legend ('Kp1=200', 'Kp2=300', 'Kp3=400');
grid on;
%% 输入（控制量）与时间关系
figure(2, 'position',[200 100 700 400]);
plot (t,u1,"linewidth",1);
hold on;
plot (t,u2,"linewidth",1);
plot (t,u3,"linewidth",1);
xlim ([0 200]);
ylim ([-10000 2200]);
grid on;
legend ('Kp1=200', 'Kp2=300', 'Kp3=400');
