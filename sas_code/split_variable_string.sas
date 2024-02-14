
%macro split_variable_string(str = , var_name = , del = %str( ), log_message = n);

	%global &var_name._loops;

	/* Initialise the number of loops. */
	%let loops = 1;

	/* Find the first variable. */
	%let temp = %scan(&str. ,&loops. ,&del.);

	%do %until (&temp. = %str( ));
		%global &var_name.&loops.;

		%let &var_name.&loops. = &temp;

		%if %upcase("&log_message") = "Y" %then
		%do;
			%log_message(&var_name.&loops is &&&var_name.&loops.);
		%end;

		%let loops = %eval(&loops. + 1);
		%let temp = %scan(&str. ,&loops. ,&del);
	%end;

	/* Reduce the counter by 1. */
	%let &var_name._loops = %eval(&loops. - 1);

	%if %upcase("&log_message") = "Y" %then
	%do;
		%log_message(Loop counter is &var_name._loops and = &&&var_name._loops);
	%end;

%mend;