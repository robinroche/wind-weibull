# Computing Weibull distribution parameters from a wind speed time series

This Matlab script computes the Weibull distribution parameters from wind speed data.

### Licence

None. Feel free to use it as you wish.

### Context

The frequency of wind speeds at a specific location can generally be modeled with a probability density function, the [http://en.wikipedia.org/wiki/Weibull_distribution](Weibull distribution). Its parameters can be determined using several methods presented in the papers listed below. The only required input data is a wind speed time series for the selected location.

### Determination method

I implemented a script in Matlab that extracts these parameters from a simple time series of measurements spanning several months. The determination method I used is the simple graphic method.

### Sample output

Sample Weibull probability density functions:
![Sample script output](http://robinroche.com/webpage/images/Weibull.png)

### References

The following papers describe several Weibull distribution parameters determination methods:
- Akdag, S.A. and Dinler, A., A new method to estimate Weibull parameters for wind energy applications, Energy Conversion and Management, 50:7 1761–1766, 2009
- Seguro, J.V. and Lambert, T.W., Modern estimation of the parameters of the Weibull wind speed distribution for wind energy analysis, Journal of Wind Engineering and Industrial Aerodynamics, 85:1 75–84, 2000

### Contact

Robin Roche - robinroche.com
