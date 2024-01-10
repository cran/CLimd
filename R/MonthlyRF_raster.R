#' Generating Monthly Rainfall Rasters from IMD NetCDF file
#'
#' @param nc_data Path to the IMD rainfall NetCDF file
#' @param output_dir Directory to save the generated monthly rainfall raster (Optional)
#' @param fun Aggregation function ("sum", "min", "max", "mean", "sd")(Default is "sum")
#' @param year Year for which to generate monthly rainfall raster
#'
#' @return A list of monthly rainfall rasters in GeoTIFF format
#' @examples
#' \donttest{
#' library(CLimd)
#' # Example usage:
#' nc_data <- system.file("extdata", "imd_RF_2022.nc", package = "CLimd")
#' output_dir <- NULL
#' fun<-"sum"
#' year<-2022
#' # Calculate monthly rainfall sums for 2022
#' monthly_rainfall <-MonthRF_raster(nc_data, output_dir=NULL, fun="sum", year)
#' # Calculate monthly rainfall means for 2022
#' fun<-"mean"
#' monthly_rainfall_means <- MonthRF_raster(nc_data, output_dir=NULL, fun="mean", year)
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
MonthRF_raster <- function(nc_data, output_dir=NULL, fun="sum", year) {
  # Load the NetCDF file
  rs <- stack(nc_data)
  # Attribute name for each raster stacked
  start_date <- as.Date(paste0(year, "-01-01"))
  end_date <- as.Date(paste0(year, "-12-31"))
  nameindex <- seq(start_date, end_date, '1 day')
  # Rename the stack
  names(rs) <- nameindex

  # Get the date from the names of the layers and extract the month
  indices <- format(as.Date(names(rs), format = "X%Y.%m.%d"), format = "%m")
  indices <- as.numeric(indices)

  # Apply the specified function for monthly aggregation
  MonthRF<- stackApply(rs, indices, fun = match.fun(fun))
  names(MonthRF) <- month.abb

  # Save monthly rasters (Optional)
  if (!is.null(output_dir)) {
    writeRaster(MonthRF, filename = paste0(output_dir, "/", month.abb, "_", year, ".tif"),
                 bylayer = TRUE, format = "GTiff", overwrite = TRUE)
  }

  return( MonthRF)
}

