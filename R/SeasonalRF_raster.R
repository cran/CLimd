#' Generating Seasonal rainfall rasters from IMD NetCDF file
#'
#' @param nc_data Path to the IMD rainfall NetCDF file
#' @param output_dir Directory to save the generated seasonal rainfall rasters (Optional)
#' @param fun Aggregation function ("sum", "min", "max", "mean", "sd")(Default is "sum")
#' @param year Year for which to generate seasonal rainfall raster
#'
#' @return Returns a list containing the four seasonal rasters in GeoTIFF format
#' @examples
#' \donttest{
#' library(CLimd)
#' # Example usage:
#' nc_data <- system.file("extdata", "imd_RF_2022.nc", package = "CLimd")
#' output_dir <- NULL
#' fun<-"sum"
#' year<-2022
#' # Calculate seasonal rainfall sum for 2022
#' seasonal_rainfall <-SeasonalRF_raster(nc_data, output_dir=NULL, fun="sum", year)
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
SeasonalRF_raster <- function(nc_data, output_dir=NULL, fun="sum", year) {
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

  # Extract layers for Winter Season (January and February)
  Winter_stack<-stack(MonthRF$Jan,MonthRF$Feb)
  # Calculate seasonal rainfall
  Winter<-calc(Winter_stack, fun = match.fun(fun))

  # Extract layers for PreMonsoon Season (March, April, May)
  PreMonsoon_stack<-stack(MonthRF$Mar,MonthRF$Apr,MonthRF$May)
  # Calculate seasonal rainfall
  PreMonsoon<-calc(PreMonsoon_stack, fun = match.fun(fun))

  # Extract layers for SWMonsoon Season (June to September)
  SWMonsoon_stack<-stack(MonthRF$Jun,MonthRF$Jul,MonthRF$Aug,MonthRF$Sep)
  # Calculate seasonal rainfall
  SWMonsoon<-calc(SWMonsoon_stack, fun = match.fun(fun))

  # Extract layers for Post_monsoon Season (October to December)
  PostMonsoon_stack<-stack(MonthRF$Oct,MonthRF$Nov,MonthRF$Dec)
  # Calculate seasonal rainfall
  PostMonsoon<-calc(PostMonsoon_stack, fun = match.fun(fun))

  # Save seasonal rasters (optional)
  if (!is.null(output_dir)) {
    seasons <- c("Winter", "PreMonsoon", "SWMonsoon", "PostMonsoon")
    for (season in seasons) {
      filename <- paste0(output_dir, "/", season, "_", year, ".tif")
      writeRaster(get(season), filename = filename, format = "GTiff", overwrite = TRUE)
    }
  }


  return(list(Winter = Winter, PreMonsoon = PreMonsoon, SWMonsoon = SWMonsoon, PostMonsoon = PostMonsoon))

}

