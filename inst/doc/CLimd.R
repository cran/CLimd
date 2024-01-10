## -----------------------------------------------------------------------------
### Installation and loading the library of CLimd R package
# You can install the CLimd package from CRAN using the following command:
# install.packages("CLimd")
# Once installed, you can load the package using
library(CLimd)

###  Generating Monthly Rainfall Rasters from IMD NetCDF Data
# The "MonthRF_raster" function generates the monthly rainfall rasters.

# Example:
nc_data <- system.file("extdata", "imd_RF_2022.nc", package = "CLimd")
output_dir <- NULL
fun<-"sum"
year<-2022
# nc_data: Path to the IMD NetCDF rainfall file.
# output_dir: Directory to save the generated rasters. (Optional)
# fun: Aggregation function ("sum", "min", "max", "mean", "sd").
# year: Year for which to generate monthly rasters.

# Calculate monthly rainfall sum for the year 2022
MonthRF<-MonthRF_raster(nc_data, output_dir=NULL, fun="sum", year)
MonthRF
### This creates a list of 12 rasters, one for each month in 2022. Each raster provides a detailed snapshot of rainfall distribution for that specific month. You can visualize these rasters using the plot function to gain insights into monthly trends and variations in rainfall patterns
# plot(MonthRF[[1]])  # Plot the first layer (Jan)
# plot(MonthRF)  # Plot all layers (Jan to Dec) as a multi-panel display

###  Generating Weekly Rainfall Rasters from IMD NetCDF Data
# The "WeeklyRF_raster" function generates weekly rainfall rasters. Example:
library(CLimd)
nc_data <- system.file("extdata", "imd_RF_2022.nc", package = "CLimd")
output_dir <- NULL
fun<-"sum"
year<-2022
WeekRF<-WeeklyRF_raster(nc_data, output_dir=NULL, fun="sum", year)
WeekRF
### This creates a list of 52 rasters, one for each week in 2022. You can visualize them using the plot function to explore rainfall dynamics at a weekly scale.
# plot(WeekRF)
# plot(WeekRF[[45:52]])
###  Generating Seasonal Rainfall Rasters from IMD NetCDF Data
# According to the IMD, four prominent seasons namely (i) Winter (December-February), (ii) Pre-Monsoon (March–May), (iii) Monsoon (June-September), and (iv) Post-Monsoon (October-November) are dominant in India.
# The "SeasonalRF_raster" function generates seasonal rainfall rasters. Example:
library(CLimd)
nc_data <- system.file("extdata", "imd_RF_2022.nc", package = "CLimd")
output_dir <- NULL
fun<-"sum"
year<-2022
SeasonalRF<-SeasonalRF_raster(nc_data, output_dir=NULL, fun="sum", year)
SeasonalRF
### This creates a set of 4 rasters representing the four seasons (Winter, Pre-Monsoon, Monsoon, and Post-Monsoon) of 2022. Visualize them using the plot function to uncover seasonal rainfall patterns and their impacts
# plot(SeasonalRF$Winter)
# plot(SeasonalRF$PreMonsoon)
# plot(SeasonalRF$SWMonsoon)
# plot(SeasonalRF$PostMonsoon)

###  Generating Annual Rainfall Raster from IMD NetCDF Data
# The "AnnualRF_raster" function generates annual rainfall raster. Example:
library(CLimd)
nc_data <- system.file("extdata", "imd_RF_2022.nc", package = "CLimd")
output_dir <- NULL
fun<-"sum"
year<-2022
AnnualRF<-AnnualRF_raster(nc_data, output_dir=NULL, fun="sum", year)
AnnualRF
### This generates a single raster summarizing the total rainfall for the entire year 2022. Plot this raster to visualize the overall rainfall distribution and identify areas of high and low precipitation.
# plot(AnnualRF)


