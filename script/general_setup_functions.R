UsePackage <- function(p) {
  # Installs the package if it hasn't already been installed.
  # Includes the library into the session, if the package has been installed.
  #
  # Args:
  #   p: package name
  #   installed.packages(): The other vector. x and y must have the same length, greater 
  #                         than one, with no missing values.
  # 
  # Returns:
  #   N/A
  if (!is.element(p, installed.packages()[,1])){
    install.packages(p, dep = TRUE)
  }
  require(p, character.only = TRUE)
}