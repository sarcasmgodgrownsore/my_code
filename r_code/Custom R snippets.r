# Custom code snippets

snippet rml
	rm(list=ls())

snippet lj
	${1:new_data} <- ${2:df1} %>%
		left_join(${3:df2}, by = "${4:by_var}")

snippet ij
	${1:new_data} <- ${2:df1} %>%
		inner_join(${3:df2}, by = "${4:by_var}")

snippet rj
	${1:new_data} <- ${2:df1} %>%
		right_join(${3:df2}, by = "${4:by_var}")



snippet rscript
	# ${1:Description}
	
	# Author: ${2:Name}
	# Version: `r Sys.Date()`
	
	# Packages
	library(tidyverse)
	
	# Parameters
	
	# ============================================================================
	
	${3:# Code}


snippet rml
	rm(list=ls())

snippet lj
	${1:new_data} <- ${2:df1} %>%
		left_join(${3:df2}, by = "${4:by_var}")

snippet ij
	${1:new_data} <- ${2:df1} %>%
		inner_join(${3:df2}, by = "${4:by_var}")

snippet rj
	${1:new_data} <- ${2:df1} %>%
		right_join(${3:df2}, by = "${4:by_var}")

snippet readc
	${1:new_data} <- read.csv("${2:input_file}.csv",
	    header = TRUE, 
	    sep = ",", 
	    quote = "\"")
	    
snippet writec
	write.csv(${1:new_data},
		file = "${2:output_file}.csv",
		append = FALSE)
		
snippet reads
	saspath <- "${1:saspath}"
	setwd(saspath)
	new_data <- haven::read_sas("${2:in_ds}") 
