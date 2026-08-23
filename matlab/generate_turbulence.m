function irradiance = generate_turbulence(N,sigma_turb)
%GENERATE_TURBULENCE Generate normalized atmospheric irradiance samples.
%
% A log-normal irradiance model is used as a baseline weak-to-moderate
% turbulence representation. sigma_turb controls fluctuation strength.

X = -0.5*sigma_turb^2 + sigma_turb*randn(N,1);
irradiance = exp(X);
irradiance = irradiance/mean(irradiance);
end
