
%macro replace_missing(in_vars, num_miss_val, char_miss_val);

	%let rmi = 0;

	%do %until (%scan(&in_vars.,&rmi,' ')=%str( )) ;
		%let rmi = %eval(&rmi+1);

		%let invar = %scan(&in_vars.,&rmi,' ');
	   	%if &invar ne %str( ) %then
		%do;
			if missing(&invar.) then
			do;
				if vtype(&invar.) = "N" then
					&invar. = &num_miss_val;

				else if vtype(&invar.) = "C" then
					&invar. = "&char_miss_val";
			end;
		%end;
	%end;

%mend replace_missing;
