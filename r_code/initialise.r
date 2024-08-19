# install_packages function: install and load multiple R packages.
# Check to see if packages are installed. Install them if they are not, then load them into the R session.
install_packages <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg)) 
        install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
}

package_list <- c("tidyverse", # Tidyverse
                  "janitor",
                  "matlib"
                 )
