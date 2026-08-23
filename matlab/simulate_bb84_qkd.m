function [qber,skr] = simulate_bb84_qkd(effective_snr,irradiance,cfg)
%SIMULATE_BB84_QKD Estimate QBER and secure key rate for BB84.
%
% This is a performance-oriented BB84 model. It captures turbulence-
% dependent transmission, detector efficiency, basis sifting, channel
% errors and a security threshold. It is not a photon-level hardware
% implementation or a finite-key security proof.

channel_transmission = mean(min(irradiance,1));
detection_probability = channel_transmission*cfg.detector_efficiency;

sifted_key_rate = cfg.qkd_pulse_rate*...
    detection_probability*cfg.basis_matching_probability;

sigma_equivalent = std(irradiance-1);
turbulence_error = 0.01 + 0.08*sigma_equivalent;
channel_error = 0.02*exp(-mean(effective_snr));

qber = turbulence_error + channel_error + cfg.dark_count;
qber = min(max(qber,0),0.5);

if qber < cfg.qber_threshold
    H2 = -qber*log2(qber+eps) - ...
         (1-qber)*log2(1-qber+eps);

    secure_fraction = 1 - ...
        cfg.error_correction_efficiency*H2 - H2;

    secure_fraction = max(secure_fraction,0);
    skr = sifted_key_rate*secure_fraction;
else
    skr = 0;
end
end
