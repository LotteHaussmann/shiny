### plotting function

#packages
r <- getOption("repos")
r["CRAN"] <-"https://cloud.r-project.org/"
options(repos=r)


if (!require(ggplot2)) {
  install.packages("ggplot2")
  require(ggplot2)
}



### function plot variable (with ggplot)

func_plot <- function(data, variable){
  #check variable in data frame
  if (!(variable %in% names(data))) {
    stop("Variable not found in data frame")
  }
  # check variable numeric  
#  if(!is.numeric(data[[variable]])) {
#    stop("Variable is not numeric")
#  }
  
  #plotting 
  ggplot(data, aes_string(x = variable)) +
    geom_bar(fill = "skyblue", color = "black") +
    labs(title = paste("Histogram of", variable),
         x = variable,
         y = "Frequency") +
    theme_minimal()
  
}


