# PlasmaChemicalGUI

## Supported data sources

result*.mat
result*.nc

species,
theta, sigma, temp_e, temp

## Functions

find significant values in data array

plot species concentration
plot species emission velocity
plot theta
plot sigma
plot temp
plot temp_e


plot_1
plot_2
plot_23

by t,z with specified r, time range, z range
by t,r with specified z, time range, r range
by z,r with specified t, z range, r range
    (nearest existing value used if specified value of t,z,r not in tt,zz,rr)

plot sinks and sources by z, r in specified t range

save to file

# API
concato
emissio
proximo
reducto

## Notes

cut data before plotting

Configuro.
Parameters: yml or json or xml or ini? Нужен парсер этого для Matlab.
