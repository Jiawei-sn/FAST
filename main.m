%% Far-field amplitude-only speckle transfer (FAST) method
% Nvidia GPU is required for running the code
%
% Copyright to Jiawei SUN & Jiachen WU, 09.04.2022

clear;
close all;clc

%% load and set parameters
load data.mat

A(:,:,1) = amp_far_ref_a;
A(:,:,2) = amp_far_ref_b;
clear amp_far_ref_a amp_far_ref_b

mask = imbinarize(amp_facet_ref,0.02);
mask = imclose(mask,strel('disk',10));
% figure;imagesc(mask);axis image off;colormap gray;title('Binary mask');

if gpuDeviceCount > 0  %GPU
    A = gpuArray(A); 
    amp_facet_ref = gpuArray(amp_facet_ref);
    amp_far_sam = gpuArray(amp_far_sam);
end

[Ny,Nx] = size(amp_far_sam);

dp = 2.2e-6;
lambda = 532e-9;
imgNum = length(zs);
b = 0.2;

% init_phase = 2*pi*rand([Ny,Nx]);
init_phase = 0;

%% Reconstruct the phase distortion
if gpuDeviceCount == 0
    Uo = mask.*exp(1i*init_phase);%no GPU
    Un = zeros(Ny,Nx,imgNum);
else
    Uo = gpuArray(mask.*exp(1i*init_phase));%GPU
    Un = gpuArray(zeros(Ny,Nx,imgNum));
end

iters = 2500;
k = 1;
for k = k + 1:k + iters
    for n = 1:imgNum
        Ui = prop(Uo,dp,dp,lambda,zs(n));
        Ua = A(:,:,n).*Ui./abs(Ui);
        Um = prop(Ua,dp,dp,lambda,-zs(n));
        Uo = ((1+b)*Um - Uo).*mask + Uo - b*Um;
        Un(:,:,n) = Uo;
    end
    Uo = mean(Un,3);
    
    if mod(k,20) == 0       
        amp_cc(k-1) = gather(corr2(abs(Uo),amp_facet_ref));
        phase_ref = angle(Uo);
        figure(2001); title(['iteration = ' num2str(k)]);
        subplot(2,2,1);imagesc(abs(Uo));axis image;axis off;title('facet amp recon');
        subplot(2,2,2);imagesc(phase_ref);axis image;axis off;title('phase reconstructcion');
        subplot(2,2,[3,4]);plot(amp_cc);title(['Amplitude correlation iteration = ' num2str(k)]);
    end    
end

phase_ref = angle(Uo);

%% Reconstruct the phase of the sample
N = 40;
z = zs(1);
A_sam = amp_far_sam;
Uo = mask.*exp(1i*phase_ref);

k = 1;
for k = k + 1:k + N
    
    Ui = prop(Uo,dp,dp,lambda,z);
    Ua = A_sam.*Ui./abs(Ui);
    Um = prop(Ua,dp,dp,lambda,-z);
    Uo = ((1+b)*Um - Uo).*mask + Uo - b*Um;
    
    if mod(k,10) == 0
        phase_sam = angle(Uo);
        phase_diff = wrapToPi(phase_sam - phase_ref);
        figure(2002);
        subplot(1,2,1);imagesc(abs(Uo));axis image off;title('facet amplitude reconstruction');
        subplot(1,2,2);imagesc(phase_diff);axis image off;title('phase sample');
    end
end

% % Correct the wavefront tilt
% tiltAngleX = 0.04;
% tiltAngleY = 0.03;
% img_center = [1246 928];
% tilt = tiltPhase(size(phase_diff), tiltAngleX, tiltAngleY, img_center);
% phase_diff = wrapToPi(tilt + phase_diff); %tilt correction
% figure(74);imagesc(phase_diff);axis image off;title('Corrected phase')

% Display the reconstructed phase
phase_target = wrapToPi(phase_sam-phase_ref+4.1).*mask;
phase_med_mcf = medfilt2(phase_target,[11 11]); 
figure; imagesc(phase_med_mcf);colormap parula;axis off image;
colorbar;title('Phase target reconstruction');

