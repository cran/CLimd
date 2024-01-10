#' Generating Annual rainfall raster from IMD NetCDF file
#'
#' @param nc_data Path to the IMD rainfall NetCDF file
#' @param output_dir Directory to save the generated annual rainfall raster (Optional)
#' @param fun Aggregation function ("sum", "min", "max", "mean", "sd")(Default is "sum")
#' @param year Year for which to generate annual rainfall raster
#' @return Annual rainfall raster in GeoTIFF format
#' @examples
#' \donttest{
#' library(CLimd)
#' # Example usage:
#' nc_data <- system.file("extdata", "imd_RF_2022.nc", package = "CLimd")
#' output_dir <- NULL
#' fun<-"sum"
#' year<-2022
#' # Calculate annual rainfall sum for 2022
#' annual_rainfall_sum<-AnnualRF_raster(nc_data, output_dir=NULL, fun="sum", year)
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
AnnualRF_raster <- function(nc_data, output_dir=NULL, fun="sum", year) {
  # Load the NetCDF file
  rs <- stack(nc_data)
  # Calculate annual rainfall sum from daily data
  AnnualRF<- calc(rs, fun =  match.fun(fun))
  # Save Annual raster (Optional)
  if (!is.null(output_dir)) {
    writeRaster(AnnualRF, filename = paste0(output_dir,"/", "Annual_", year, ".tif"), bylayer = TRUE, format = "GTiff", overwrite = TRUE)
  }

  return(AnnualRF)
}


