# System Architecture

## Hybrid Classical–Quantum FSO Backhaul

The project models a 5G optical backhaul with two logical channels over the optical link:

1. **Classical FSO channel**: carries high-rate 5G traffic.
2. **Quantum channel**: supports BB84-inspired quantum key distribution and secret-key generation.

```text
                         5G Core Network
                                |
                         Secure Backhaul
                                |
                 +--------------+--------------+
                 |                             |
          Classical FSO                   Quantum FSO
                 |                             |
             5G Data                       BB84 QKD
                 |                             |
                 |                        QBER / SKR
                 |                             |
                 +-------------+---------------+
                               |
                         QoS-aware control
                               |
                    +----------+----------+
                    |          |          |
                  URLLC      eMBB       mMTC
```

## Channel Impairment Chain

```text
Transmitter
    |
    v
Free-space optical beam
    |
    v
Atmospheric attenuation
    |
    v
Turbulence / irradiance fluctuations
    |
    v
Received optical signal
    |
    +----------------------+
    |                      |
    v                      v
Classical metrics       Quantum metrics
BER / throughput        QBER / SKR
```

## QoS Layer

The network-slicing layer maps application requirements to different priorities:

| Slice | Primary requirement | Simulation emphasis |
|---|---|---|
| URLLC | Low latency and high reliability | Reliability/security-aware allocation |
| eMBB | High throughput | Capacity-oriented allocation |
| mMTC | Scalability and efficiency | Resource-efficient allocation |

The current implementation uses weighted utility functions to represent these priorities. This is intentionally modular so that a future version can replace the heuristic allocator with optimization, reinforcement learning, or constrained resource-allocation algorithms.

## QKD Flow

```text
Random quantum states
        |
        v
Alice -------- Quantum FSO --------> Bob
        |                              |
        +---- basis reconciliation ---+
                       |
                       v
                  Sifted key
                       |
                       v
                    QBER
                       |
                +------+------+
                |             |
          QBER acceptable   QBER too high
                |             |
                v             v
          Secure key       Abort key
             rate
```
