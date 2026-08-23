# Simulation Results

The figures in this project were generated from the MATLAB simulation using three atmospheric turbulence conditions and an SNR sweep from 0 to 30 dB.

## Included Performance Views

### 1. Classical FSO: BER vs SNR

The BER decreases with increasing SNR. Stronger atmospheric turbulence produces a slower improvement because irradiance fluctuations degrade the effective SNR.

### 2. QKD: QBER vs SNR

QBER is evaluated against the BB84 security threshold. Stronger turbulence produces a higher baseline QBER in the model.

### 3. BB84: Secret Key Rate vs SNR

The secure key rate improves as the channel becomes more favorable and is highest for weak turbulence. Key generation is disabled when QBER reaches the configured security threshold.

### 4. Conventional FSO vs QoS-Aware Hybrid FSO-QKD

The comparison shows how the QoS utility layer changes the effective service rate relative to the conventional FSO baseline under moderate turbulence.

### 5. QoS-Aware Allocation Across 5G Slices

The slice comparison demonstrates differentiated allocation for URLLC, eMBB and mMTC according to their configured QoS weights.

## Interpretation

The important result is not simply that optical communication works. The simulation connects three layers: atmospheric channel quality, quantum security performance, and application-specific 5G QoS. This makes the model suitable as a baseline for future work involving more rigorous turbulence and finite-key models.
