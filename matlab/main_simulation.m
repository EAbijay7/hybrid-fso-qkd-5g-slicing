%% HYBRID CLASSICAL-QUANTUM FSO LINKS
% QoS-Aware QKD for 5G Network Slicing
%
% Main simulation driver.
% Generates BER, QBER, secret-key-rate and QoS-aware throughput results.

clear;
clc;
close all;

%% Configuration
cfg.N = 100000;
cfg.SNR_dB = 0:2:30;
cfg.turbulence_names = {'Weak','Moderate','Strong'};
cfg.sigma_turb = [0.05 0.20 0.45];
cfg.distance_km = 2;
cfg.wavelength = 1550e-9;
cfg.transmit_power = 1;
cfg.bandwidth = 10e9;
cfg.qkd_pulse_rate = 1e9;
cfg.detector_efficiency = 0.80;
cfg.basis_matching_probability = 0.50;
cfg.error_correction_efficiency = 1.16;
cfg.dark_count = 1e-6;
cfg.qber_threshold = 0.11;

% QoS weights: latency, throughput, reliability
cfg.slice_names = {'URLLC','eMBB','mMTC'};
cfg.QoS_latency = [0.60 0.10 0.20];
cfg.QoS_throughput = [0.20 0.70 0.30];
cfg.QoS_reliability = [0.20 0.20 0.30];

%% Run physical-layer simulations
numTurb = numel(cfg.sigma_turb);
numSNR = numel(cfg.SNR_dB);

BER = zeros(numTurb,numSNR);
QBER = zeros(numTurb,numSNR);
SKR = zeros(numTurb,numSNR);
throughput_conventional = zeros(numTurb,numSNR);
throughput_qos = zeros(numTurb,numSNR);

fprintf('\n=============================================\n');
fprintf(' Hybrid Classical-Quantum FSO Simulation\n');
fprintf('=============================================\n');

for t = 1:numTurb
    fprintf('Simulating %s turbulence...\n',cfg.turbulence_names{t});
    irradiance = generate_turbulence(cfg.N,cfg.sigma_turb(t));

    for s = 1:numSNR
        [BER(t,s),throughput_conventional(t,s),effective_snr] = ...
            simulate_classical_fso(cfg.SNR_dB(s),irradiance,cfg.bandwidth);

        [QBER(t,s),SKR(t,s)] = simulate_bb84_qkd(...
            effective_snr,irradiance,cfg);
    end
end

%% QoS-aware resource allocation
for t = 1:numTurb
    for s = 1:numSNR
        throughput_qos(t,s) = qos_allocator(...
            throughput_conventional(t,s),BER(t,s),QBER(t,s),cfg);
    end
end

%% Plot and save results
results.SNR_dB = cfg.SNR_dB;
results.BER = BER;
results.QBER = QBER;
results.SKR = SKR;
results.throughput_conventional = throughput_conventional;
results.throughput_qos = throughput_qos;
results.turbulence_names = cfg.turbulence_names;
results.slice_names = cfg.slice_names;
results.config = cfg;

plot_results(results);
save('simulation_results.mat','results');

%% Numerical summary
fprintf('\n=============================================\n');
fprintf(' Simulation Summary\n');
fprintf('=============================================\n');
for t = 1:numTurb
    fprintf('\n%s Turbulence\n',cfg.turbulence_names{t});
    fprintf('Minimum BER        : %.4e\n',min(BER(t,:)));
    fprintf('Maximum BER        : %.4e\n',max(BER(t,:)));
    fprintf('Minimum QBER       : %.4f\n',min(QBER(t,:)));
    fprintf('Maximum QBER       : %.4f\n',max(QBER(t,:)));
    fprintf('Maximum SKR        : %.4e bits/s\n',max(SKR(t,:)));
    fprintf('Maximum QoS rate   : %.4e bits/s\n',max(throughput_qos(t,:)));
end

fprintf('\nResults saved to simulation_results.mat\n');
