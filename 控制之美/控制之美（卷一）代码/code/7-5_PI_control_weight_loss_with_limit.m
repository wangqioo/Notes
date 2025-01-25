%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 《控制之美-卷一(第二版)》 代码
%% 作者：王天威
%% 清华大学出版社
%% 程序名称：7-5_PI_Control_Weight_Loss_with_Limit.m
%% 程序功能：含限制的比例积分控制_体重模型
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 程序初始化，清空工作空间，缓存
clear all;
close all;
clc;
% 读取Octave控制和信号数据库（注：如使用Matlab，可删除或注释掉本行代码）
pkg load control
%%%%%%%%%%%%%%%%%系统定义%%%%%%%%%%%%%%%%%%%%%
%%约束条件引入了非线性，因此传递函数将无法继续使用，使用ode45求解微分方程
function  dx = sys_weight_loss_limit(t,x)
%%%%%%%%%%%%%%%%%输入定义%%%%%%%%%%%%%%%%%%%%%
  r = 65;
  %% 定义系统变量
  S = 5;
  h = 175;
  a = 20;
  alpha = 1.3;
  %% 定义扰动量
  d = -alpha * (6.25 * h - 5 * a + S);
  e = r - x(1);
  % 更新误差积分
  eint = x(2) + e;
  %% 定义PI控制器
  kp = 200;
  ki = 1;
  u = kp*e + ki*eint;
  if u > 5000
    u = 5000;
  elseif u<1000
    u = 1000;
  endif
  %% x(1) 为体重，原系统X
  %% x(2) 为误差
  dx(1) = ( u + d - 10*alpha*x(1))/7000;
  dx(2) = e;

 end
%% 定义初始体重
x0 = [90;0];
%% 定义初始误差积分
e_int = 0;
%% 定义参考目标
r = 65;
%% 设定仿真时间
tspan = 0:1:1000;
%% 求解微分方程
[t, x] = ode45(@sys_weight_loss_limit, tspan, x0);
%% 计算控制量u
%% 定义绘制的控制量u_plot
u_plot =zeros(length(t),1);
for k = 1:length(t)
  %% 计算误差
    e = r - x(k,1);
  %% 更新误差积分
    eint = x(k,2) + e;
  %% 定义PI控制器
    kp = 200;
    ki = 1;
    u = kp*e + ki*eint;
    if u > 5000
        u = 5000;
    elseif u<1000
        u = 1000;
    endif
    u_plot(k) = u;
end

%% 绘图
figure(1, 'position',[200 100 600 300]);
plot (t,x(:,1));
grid on;
figure(2, 'position',[200 100 600 300]);
plot (t,u_plot);
grid on;;



