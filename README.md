# Evaluation of Interference Cancellation Architectures for Heterogeneous Cellular Networks


## Abstract:

> With the increasing data throughput requirements, the cellular network needs to move from homogeneous to heterogeneous system. In fact, the coexistence of different types of base stations with different capabilities such as femto/pico base stations as well as relays and macro base stations in random placements should improve the coverage and the spectral efficiency of the cellular networks.
> 
> However, the complexity of inter-cell interference management will grow drastically and traditional interference avoidance/mitigation approaches need to be revised. Approaching this problem at the user equipment (UE), is of great interest since it can rely on little coordination among base stations.
>  The work presented in this thesis focuses on a downlink interference cancellation at the UE and shows that such an intelligent receiver can bring its promised benefit only if the base stations get involved in the interference cancellation, specifically in the channel estimation process. The limitations of this approach are evaluated and depending on the surrounding base stations two solutions are proposed and discussed.


## Structure of the Simulator

This repos is dedicated to the Matlab implementation of a BICM based OFDMA transceiver system in the equivalent baseband. We assume that the time and frequency resources are organized as in the LTE standard, but without considering all the details and only the downlink transmission scheme is considered.
A particular focus here is the performance of the interference aware receiver in an inter-cell interference environment with one dominant interferer. Additional optimization techniques are also implemented such as boosted pilot symbols in the interferer and REs puncturing in the signal of interest.
In fact, LTE standard allows a certain degree of freedom in the signal generation, which makes these two optimization techniques easy to incorporate in real systems.

The following fig. shows the general code structure of the simulation testbed, which is composed of five main building blocks:

1. Control unit, which is used to control the behaviour and priorities of the different components of the implementation, some of the parameters are set as default and others are adjustable.
2. Serving eNodeB,
3. Interferer eNodeB,
4. Virtual Channel,
5. UE


[Fig](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/ded9bc49-dbb3-4976-9005-4960496464e8/Untitled.png)

