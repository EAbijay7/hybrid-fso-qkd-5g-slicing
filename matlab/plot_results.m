function plot_results(results)
%PLOT_RESULTS Generate the main performance figures.

SNR_dB = results.SNR_dB;
BER = results.BER;
QBER = results.QBER;
SKR = results.SKR;
throughput_conventional = results.throughput_conventional;
throughput_qos = results.throughput_qos;
turbulence_names = results.turbulence_names;

qber_threshold = results.config.qber_threshold;

%% BER vs SNR
figure;
for t = 1:numel(turbulence_names)
    semilogy(SNR_dB,BER(t,:),'LineWidth',2);
    hold on;
end
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('Classical FSO: BER vs SNR');
legend(turbulence_names,'Location','southwest');

%% QBER vs SNR
figure;
for t = 1:numel(turbulence_names)
    plot(SNR_dB,QBER(t,:),'LineWidth',2);
    hold on;
end
yline(qber_threshold,'--','QBER Security Threshold','LineWidth',1.5);
grid on;
xlabel('SNR (dB)');
ylabel('Quantum Bit Error Rate (QBER)');
title('QKD Performance: QBER vs SNR');
legend(turbulence_names,'Location','best');

%% Secret key rate vs SNR
figure;
for t = 1:numel(turbulence_names)
    semilogy(SNR_dB,SKR(t,:),'LineWidth',2);
    hold on;
end
grid on;
xlabel('SNR (dB)');
ylabel('Secret Key Rate (bits/s)');
title('BB84 QKD: Secret Key Rate vs SNR');
legend(turbulence_names,'Location','best');

%% Conventional FSO vs QoS-aware hybrid FSO-QKD
figure;
t = 2;
plot(SNR_dB,throughput_conventional(t,:)/1e9,'LineWidth',2);
hold on;
plot(SNR_dB,throughput_qos(t,:)/1e9,'--','LineWidth',2);
grid on;
xlabel('SNR (dB)');
ylabel('Throughput (Gbps)');
title('Conventional FSO vs QoS-Aware Hybrid FSO-QKD');
legend('Conventional FSO','QoS-Aware Hybrid FSO-QKD',...
    'Location','southeast');

%% Slice allocation at 20 dB, moderate turbulence
selected_snr = 20;
[~,idx] = min(abs(SNR_dB-selected_snr));
current_throughput = throughput_conventional(t,idx);
current_ber = BER(t,idx);
current_qber = QBER(t,idx);

reliability_score = max(0,1-current_ber);
if current_qber < qber_threshold
    security_score = max(0,1-current_qber/qber_threshold);
else
    security_score = 0;
end
throughput_score = current_throughput/results.config.bandwidth;

slice_results = zeros(1,numel(results.slice_names));
for k = 1:numel(results.slice_names)
    utility = ...
        results.config.QoS_throughput(k)*throughput_score + ...
        results.config.QoS_reliability(k)*reliability_score + ...
        results.config.QoS_latency(k)*security_score;
    slice_results(k) = current_throughput*utility;
end

figure;
bar(slice_results/1e9);
grid on;
set(gca,'XTickLabel',results.slice_names);
xlabel('5G Network Slice');
ylabel('Allocated Throughput (Gbps)');
title('QoS-Aware Resource Allocation Across 5G Slices');
end
