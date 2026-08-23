function qos_rate = qos_allocator(current_throughput,current_ber,current_qber,cfg)
%QOS_ALLOCATOR Apply slice-specific QoS weighting.
%
% URLLC emphasizes reliability and latency-sensitive service.
% eMBB emphasizes throughput.
% mMTC emphasizes resource-efficient operation.

num_slices = numel(cfg.slice_names);
reliability_score = max(0,1-current_ber);

if current_qber < cfg.qber_threshold
    security_score = max(0,1-current_qber/cfg.qber_threshold);
else
    security_score = 0;
end

throughput_score = current_throughput/cfg.bandwidth;
slice_rate = zeros(1,num_slices);

for k = 1:num_slices
    utility = ...
        cfg.QoS_throughput(k)*throughput_score + ...
        cfg.QoS_reliability(k)*reliability_score + ...
        cfg.QoS_latency(k)*security_score;

    slice_rate(k) = current_throughput*utility;
end

qos_rate = mean(slice_rate);
end
