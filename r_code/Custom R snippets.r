snippet lib
	library(${1:package})

snippet req
	require(${1:package})

snippet src
	source("${1:file.R}")

snippet ret
	return(${1:code})

snippet mat
	matrix(${1:data}, nrow = ${2:rows}, ncol = ${3:cols})

snippet sg
	setGeneric("${1:generic}", function(${2:x, ...}) {
		standardGeneric("${1:generic}")
	})

snippet sm
	setMethod("${1:generic}", ${2:class}, function(${2:x, ...}) {
		${0}
	})

snippet sc
	setClass("${1:Class}", slots = c(${2:name = "type"}))

snippet if
	if (${1:condition}) {
		${0}
	}

snippet el
	else {
		${0}
	}

snippet ei
	else if (${1:condition}) {
		${0}
	}

snippet fun
	${1:name} <- function(${2:variables}) {
		${0}
	}

snippet for
	for (${1:variable} in ${2:vector}) {
		${0}
	}

snippet while
	while (${1:condition}) {
		${0}
	}

snippet switch
	switch (${1:object},
		${2:case} = ${3:action}
	)

snippet apply
	apply(${1:array}, ${2:margin}, ${3:...})

snippet lapply
	lapply(${1:list}, ${2:function})

snippet sapply
	sapply(${1:list}, ${2:function})

snippet mapply
	mapply(${1:function}, ${2:...})

snippet tapply
	tapply(${1:vector}, ${2:index}, ${3:function})

snippet vapply
	vapply(${1:list}, ${2:function}, FUN.VALUE = ${3:type}, ${4:...})

snippet rapply
	rapply(${1:list}, ${2:function})

snippet ts
	`r paste("#", date(), "------------------------------\n")`

snippet shinyapp
	library(shiny)
	
	ui <- fluidPage(
	  ${0}
	)
	
	server <- function(input, output, session) {
	  
	}
	
	shinyApp(ui, server)

snippet shinymod
	${1:name}UI <- function(id) {
	  ns <- NS(id)
	  tagList(
		${0}
	  )
	}
	
	${1:name}Server <- function(id) {
	  moduleServer(
	    id,
	    function(input, output, session) {
	      
	    }
	  )
	}




# Custom code snippets (all environments)
snippet git
	"https://raw.githubusercontent.com/sarcasmgodgrownsore/my_code/refs/heads/main/r_code/${1:name}"


snippet rscript
	# TITLE
	
	# ${1:Description}
	#
	#
	
	# Author: ${2:Name}
	# Version: `r Sys.Date()`
	
	
	# Packages
	library(tidyverse)
	
	
	# File paths
	
	input_path  <- ""
	graph_path  <- ""
	output_path <- ""
	
	
	
	# Parameters
	
	
	
	# ============================================================================
	
	# ${3: Code}

snippet td
	library(tidyverse)


snippet rml
	rm(list=ls())

snippet newd
	${1:new_data} <- ${2:old_data} %>%

snippet sel
	select( ) %>%

snippet fil
	filter( ) %>%

snippet mut
	mutate( ) %>%

snippet arr
	arrange( ) %>%

snippet gr
	group_by( ) %>%
	
snippet grs
	group_by( ) %>%	
	summarise(  )


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

snippet m2r
	r1 <- c();	r2 <- c()
	${1:matrix_name} <- matrix(c(r1,r2), nrow = 2, ncol = 2, byrow = TRUE,
		dimnames = list(c("r1","r2"),c("c1","c2")))

snippet m2c
	c1 <- c();	c2 <- c()
	${1:matrix_name} <- matrix(c(c1,c2), nrow = 2, ncol = 2, byrow = FALSE,
		dimnames = list(c("r1","r2"),c("c1","c2")))

snippet m3r
	r1 <- c();	r2 <- c();	r3 <- c()
	${1:matrix_name} <- matrix(c(r1,r2,r3), nrow = 3, ncol = 3, byrow = TRUE,
		dimnames = list(c("r1","r2","r3"),c("c1","c2","c3")))

snippet m3c
	c1 <- c();	c2 <- c();	c3 <- c()
	${1:matrix_name} <- matrix(c(c1,c2,c3), nrow = 3, ncol = 3, byrow = FALSE,
		dimnames = list(c("r1","r2","r3"),c("c1","c2","c3")))

snippet m4r
	r1 <- c();	r2 <- c();	r3 <- c();	r4 <- c()
	${1:matrix_name} <- matrix(c(r1,r2,r3,r4), nrow = 4, ncol = 4, byrow = TRUE,
		dimnames = list(c("r1","r2","r3","r4"),c("c1","c2","c3","c4")))

snippet m4r
	c1 <- c();	c2 <- c();	c3 <- c();	c4 <- c()
	${1:matrix_name} <- matrix(c(c1,c2,c3,c4), nrow = 4, ncol = 4, byrow = FALSE,
		dimnames = list(c("r1","r2","r3","r4"),c("c1","c2","c3","c4")))


# Custom code snippets (work only)

snippet reads
	saspath <- "${1:saspath}"
	setwd(saspath)
	new_data <- haven::read_sas("${2:in_ds}")

snippet pack
	source("Install packages.R")

snippet showc
	source("Show R colours.R")



# Custom code snippets (home only)

snippet pack
	source("home/macgregordawson/Install packages.R")

snippet showc
	source("home/macgregordawson/Show R colours.R")

snippet init
	source("https://raw.githubusercontent.com/sarcasmgodgrownsore/my_code/refs/heads/main/r_code/Global%20initialise.r")

