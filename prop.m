%% Numerical propagation
% This function use the angular spectrum method to propagate the complex
% light field numerically
% Input H - complex light field at the source plane
% dx, dy - pixel size in x and y direction
% lambda - wavelength of the light
% dist- propagation distance
% Output U - complex light field at target plane
% P - phase at the target plane
%
% Copyright to Jiawei SUN  2021
% jiawei.sun@tu-dresden.de

function [U,P] = prop(H,dx,dy,lambda,dist)

[Ny,Nx]=size(H);

fft_H=fftshift(fft2(H)); clear H UR;

[x,y]=meshgrid(1-Nx/2:Nx/2,1-Ny/2:Ny/2);
r=(2*pi*x./(dx*Nx)).^2+(2*pi*y./(dy*Ny)).^2;

k=2*pi/lambda ;
kernel=exp(-1i*sqrt(k^2-r)*dist);   % ang spec kernel

fft_HH=fft_H(:,:).*kernel;
fft_HH=fftshift(fft_HH);

U=ifft2(fft_HH);

P=angle(U);