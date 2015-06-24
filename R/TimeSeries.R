apts = ts(AirPassengers, frequency = 12)
f = decompose(apts)
plot(f)
