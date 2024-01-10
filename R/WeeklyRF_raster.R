#' Generating weekly rainfall rasters from IMD NetCDF file
#'
#' @param nc_data Path to the IMD rainfall NetCDF file
#' @param output_dir Directory to save the generated weekly rainfall rasters (Optional)
#' @param fun Aggregation function ("sum", "min", "max", "mean", "sd")(Default is "sum")
#' @param year Year for which to generate weekly rainfall raster
#'
#' @return A list of weekly rainfall rasters in GeoTIFF format
#' @examples
#' \donttest{
#' library(CLimd)
#' # Example usage:
#' nc_data <- system.file("extdata", "imd_RF_2022.nc", package = "CLimd")
#' output_dir <- NULL
#' fun<-"sum"
#' year<-2022
#' # Calculate weekly rainfall sum for 2022
#' weekly_rainfall_sum <-WeeklyRF_raster(nc_data, output_dir=NULL, fun="sum", year)
#' }
#' @references
#' 1. Pai et al. (2014). Development of a new high spatial resolution (0.25° X 0.25°)Long period (1901-2010) daily gridded rainfall data set over India and its comparison with existing data sets over the region, MAUSAM, 65(1),1-18.
#' 2. Hijmans, R. J. (2022). raster: Geographic Data Analysis and Modeling. R package version 3.5-13.
#' 3. Kumar et al. (2023). SpatGRID:Spatial Grid Generation from Longitude and Latitude List. R package version 0.1.0.
#' @export
#' @import raster
#' @import ncdf4
#' @import qpdf
#'
WeeklyRF_raster <- function(nc_data, output_dir=NULL, fun="sum", year) {
  # Load the NetCDF file
  rs <- stack(nc_data)
  # Extract the dates from the band names as integer
  x<-as.integer(substr(names(rs), 2, 6))
  # Convert them as date with origin of 31st December, 1900
  x1 = as.Date(x, origin=as.Date("1900-12-31"))
  # Convert them as week numbers
  x2<- strftime(x1, format = "%V")
  # Get first 7 days as list
  z1<- x2[c(1:7)]
  # Identify initial days with week number 52 of previous year
  z2<- z1[z1 %in% c("52", "53")]
  # Remove initial days with week number 52 of previous year from the main list
  x3<- x2[-(1:length(z2))]
  # Prefix "Week" to the name list
  x3.1 <- paste("Week", x3)
  # Drop initial layers with week number 52 of previous year
  rs2<- dropLayer(rs, (1:length(z2)))
  # Rename the stack layers
  names(rs2)<- x3.1

  # Get weekly sum of rasters
  WeeklyRF<- stackApply(rs2, x3.1, fun = match.fun(fun))
  # Rename
  x4<-(substr(names(WeeklyRF), 7, 13))
  names(WeeklyRF)<- x4

  # Save weekly rasters (Optional)
  if (!is.null(output_dir)) {
    writeRaster(WeeklyRF, filename = paste0(output_dir,"/", "Weekly_", year, ".tif"), bylayer = TRUE, format = "GTiff", overwrite = TRUE)

    }

  return(WeeklyRF)
}

