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
