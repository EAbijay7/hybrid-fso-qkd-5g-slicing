# Hybrid Classical-Quantum FSO Links with QoS-Aware QKD in 5G Network Slicing

MATLAB simulation of hybrid classical–quantum free-space optical (FSO) links with BB84 quantum key distribution (QKD) and QoS-aware 5G network slicing under atmospheric turbulence.

## Overview

This project studies a hybrid optical backhaul architecture in which a classical FSO channel carries high-rate 5G traffic while a quantum channel is used for secure key generation. The model evaluates the interaction between atmospheric turbulence, classical link reliability, QKD performance, and slice-specific QoS requirements.

The simulated 5G slices are:

- **URLLC**: prioritizes reliability and low-latency operation.
- **eMBB**: prioritizes high throughput.
- **mMTC**: prioritizes resource efficiency for massive device connectivity.

## System Architecture

```text
                         5G Network
                              |
                    +---------+---------+
                    |   Network Slicing |
                    +---------+---------+
                              |
             +----------------+----------------+
             |                |                |
           URLLC             eMBB             mMTC
             |                |                |
             +----------------+----------------+
                              |
                         QoS Engine
                              |
                 +------------+------------+
                 |                         |
          Classical FSO               Quantum FSO
                 |                         |
             5G Data                   BB84 QKD
                 |                         |
                 |                    Secret Key
                 +------------+------------+
                              |
                         Encryption
                              |
                       Secure Backhaul
```

## Channel and Security Model

The simulation uses a stochastic log-normal irradiance model as a baseline atmospheric turbulence model. Turbulence is represented through a variance parameter, with weak, moderate, and strong conditions evaluated independently.

The classical link uses a BPSK error model to estimate BER from the instantaneous turbulence-impaired SNR. The quantum link uses a BB84-inspired model to calculate QBER, sifted-key rate, and a secure-key-rate estimate. Key generation is suppressed when QBER exceeds the configured security threshold.

## Main Performance Metrics

- Bit Error Rate (BER)
- Quantum Bit Error Rate (QBER)
- Secret Key Rate (SKR)
- Classical throughput
- QoS-aware throughput
- Slice-specific resource allocation

## Repository Structure

```text
hybrid-fso-qkd-5g-slicing/
├── matlab/
│   ├── main_simulation.m
│   ├── generate_turbulence.m
│   ├── simulate_classical_fso.m
│   ├── simulate_bb84_qkd.m
│   ├── qos_allocator.m
│   └── plot_results.m
├── results/
│   └── graphs/
│       ├── ber_vs_snr.png
│       ├── qber_vs_snr.png
│       ├── secret_key_rate_vs_snr.png
│       ├── conventional_vs_qos_throughput.png
│       └── qos_slice_allocation.png
├── docs/
│   └── architecture.md
└── README.md
```

## Simulation Scenarios

The model evaluates three turbulence conditions:

| Condition | Relative turbulence | Purpose |
|---|---|---|
| Weak | Low | Favorable optical channel |
| Moderate | Medium | Representative operating condition |
| Strong | High | Stress-test condition |

The SNR sweep covers 0–30 dB. The baseline configuration uses a 2 km FSO link, 1550 nm optical wavelength, 10 GHz classical bandwidth, and a 1 Gpulse/s QKD pulse rate.

## Results

The included simulation results illustrate the expected system trends:

1. BER decreases as SNR increases, with stronger turbulence producing worse classical performance.
2. QBER is higher under stronger turbulence.
3. Secret key rate is reduced as turbulence becomes more severe.
4. QoS-aware allocation distributes available throughput according to URLLC, eMBB, and mMTC priorities.
5. The hybrid model provides a framework for jointly evaluating secure key generation and 5G service requirements.

## Running the Simulation

1. Open MATLAB.
2. Add the `matlab` directory to the MATLAB path.
3. Run `main_simulation.m`.
4. The script generates the performance figures and saves numerical results to `simulation_results.mat`.

No external MATLAB toolbox is required beyond standard numerical and plotting functionality.

## Important Modeling Note

This repository is a simulation study, not a claim of experimental QKD hardware validation. The BB84 implementation is a performance-oriented analytical model rather than a photon-level optical hardware implementation. Parameters are intentionally exposed in the MATLAB source so that the model can be extended with Gamma-Gamma/Málaga turbulence, pointing errors, finite-key effects, detector models, and more rigorous security analysis.

## Keywords

`FSO` `QKD` `BB84` `5G` `network-slicing` `QoS` `MATLAB` `quantum-communication` `optical-communication` `wireless-communication`
