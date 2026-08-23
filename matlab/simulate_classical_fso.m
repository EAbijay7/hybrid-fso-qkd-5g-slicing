function [ber,throughput,effective_snr] = simulate_classical_fso(SNR_dB,irradiance,bandwidth)
%SIMULATE_CLASSICAL_FSO Calculate turbulence-impaired classical FSO metrics.
%
% The baseline model uses BPSK and instantaneous SNR scaling by normalized
% atmospheric irradiance.

snr_linear = 10^(SNR_dB/10);
effective_snr = snr_linear.*irradiance;

% Coherent BPSK BER model.
ber_samples = 0.5*erfc(sqrt(effective_snr));
ber = mean(ber_samples);

% Shannon-inspired capacity estimate, capped at the configured bandwidth.
throughput = bandwidth*log2(1+mean(effective_snr));
throughput = min(throughput,bandwidth);
end
