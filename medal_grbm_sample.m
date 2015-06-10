clear all;
addpath(genpath('medal'))

% PREPROCESSING

% load images, construct 32x32 patches
images = loadimagepatches('BSR/BSDS500/data/images/train',32,32);
images = permute(images, [3,1,2]);
images = reshape(images, size(images,1), size(images, 2) * size(images, 3));
images = bsxfun(@minus, double(images), mean(images));
images = bsxfun(@rdivide, double(images), std(images));

% split images into training and test set
num_train = 25000;
num_test = 5000;
idx = randperm(size(images, 1));
images_train = images(idx(1:num_train), :);
images_test = images(idx(end-num_test+1:end), :);

% visualize 100 first images from training set
figure; myvisualize(images_train(1:100, :)')

% TRAINING

% define a model structure
[nObs,nVis] = size(images_train);
nHid = 256; % 256 HIDDEN UNITS
arch = struct('size', [nVis, nHid], 'inputType','gaussian');

% training options
opts = {'lRate',0.1, ...
        'momentum', 0.95, ...
        'beginAnneal', 3, ...
		'batchSz',100, ...
		'nEpoch',10, ...
		'wPenalty', 0, ...
		'displayEvery',100, ...
		'visFun',@visGaussianRBMLearning};
arch.opts = opts;

% initialize and train the RBM
r = rbm(arch);
r = r.train(images_train);

% visualize weights
figure; visWeights(r.W);

% TESTING

% calculate reconstruction error for test images
v1_test = images_test;
h1_test_sampled = r.hidGivVis(v1_test, 0, 1).aHid;
h1_test_probs = r.hidGivVis(v1_test, 0, 0).aHid;
v2_test_sampled = r.visGivHid(h1_test_sampled, 0).aVis;
error_test_sampled = sum(sum((v1_test - v2_test_sampled) .^ 2)) / size(v1_test, 1)
v2_test_probs = r.visGivHid(h1_test_probs, 0).aVis;
error_test_probs = sum(sum((v1_test - v2_test_probs) .^ 2)) / size(v1_test, 1)

% visualize reconstruction error
v1 = images(1:150,:);
figure; imshow(mat2gray(myvisualize(v1',15)'));
title('Original image');
h1_sampled = r.hidGivVis(v1, 0, 1).aHid;
h1_probs = r.hidGivVis(v1, 0, 0).aHid;
v2_sampled = r.visGivHid(h1_sampled, 0).aVis;
figure; imshow(mat2gray(myvisualize(v2_sampled', 15)'));
title('Reconstruction from sampled hidden units');
v2_probs = r.visGivHid(h1_probs, 0).aVis;
figure; imshow(mat2gray(myvisualize(v2_probs', 15)'));
title('Reconstruction from hidden unit probabilities');

% SAMPLING

% plot variances of changes for detecting burn-in
numsamples = 100;
burnin = 0;
thinning = 1;
range = 2:-0.5:-2;
temperatures = 10.^range;
figure;
for i = 1:length(temperatures)
    t = temperatures(i);
    disp(['temperature = ' num2str(t)])
    [energy_samples, r] = sample_energies(r, t, numsamples, burnin, thinning, false, false);
    subplot(3, 3, i);
    plot(var(energy_samples, 0, 1));
    title(['Variance of chains at temperature ' num2str(t)]);
    xlabel('Iteration');
    ylabel('Variance of chains');
    drawnow;
end

% plot autocorrelations
numsamples = 1000;
burnin = 20;
thinning = 1;
range = 2:-0.5:-2;
temperatures = 10.^range;
figure;
for i = 1:length(temperatures)
    t = temperatures(i);
    disp(['temperature = ' num2str(t)])
    energy_samples = sample_energies(r, t, numsamples, burnin, thinning, false, false);
    subplot(3, 3, i);
    acf(energy_samples(1, :)', 20);
    title(['Autocorrelations at temperature ' num2str(t)]);
    drawnow;
end

% sample 1000 times from each initial state, after discarding first 100
% number of initial states (independent chains) is determined by batch size
numsamples = 100;
burnin = 10;
thinning = 1;
video = false;
   
if video
    % create video file
    video = VideoWriter('grbm.avi');
    video.FrameRate = 25;
    open(video);
end

% keep figure open
fig = figure;

% temperature range, in powers of 10
range = 2:-0.5:-2;
temperatures = 10.^range;
energy_variances = [];
for t = temperatures;
    disp(['temperature = ' num2str(t)])
    [energy_samples, r] = sample_energies(r, t, numsamples, burnin, thinning, fig, video);
    energy_variances = [energy_variances mean(var(energy_samples, 0, 2))];
end
if video
    close(video)
end

% plot energy variance vs temperature
figure;
loglog(temperatures, energy_variances)
xlabel('temperature')
ylabel('var(E)')

% plot heat capacity vs temperature
figure;
semilogx(temperatures, energy_variances ./ (temperatures .^ 2))
xlabel('temperature')
ylabel('var(E)/(T^2)')
