

%macro create_list(in_ds = &syslast. , 
					var = sd_key ,
					where_condition =  ,
					search_var = sd_key ,
					search_condition = include ,
					drop_table = N);

	%global lookup_var;

	%let lookup_var = &search_var.;

	%if &search_var. =  %then %do;
		%let lookup_var = &var.;
	%end;

	%let clause1 = in;
	%let clause2 = or;

	%if %upcase("&search_condition") = "EXCLUDE" %then %do;
		%let clause1 = not in;
		%let clause2 = and;
	%end;

	proc contents data = &in_ds. out = contents (keep = name type varnum) noprint;
	run;

	data _null_;
		set contents;
		if upcase(name) = upcase("&var");
		if type = 1 then call symput('var_type','NUM');
		else call symput('var_type','CHAR');
	run;

	%let quotemark1 = %str();
	%let quotemark2 = %str();

	%if %upcase("&var_type") = "CHAR" %then %do;
		%let quotemark1 = %str("'"||strip);
		%let quotemark2 = %str(||"'");
	%end;

	proc sql noprint;
		create table list_elements as
		select distinct &var.
		from &in_ds.
		%if "&where_condition." ne "" %then %do;
		where &where_condition.
		%end;
		order by &var.
		;
 
		select count(*) into :tot from list_elements;

		%if %upcase("&var_type") = "CHAR" %then %do;
		select (max(length(&var.)) + 3) into :element_length from list_elements;
		%end;
	quit;

		%if %upcase("&var_type") = "NUM" %then %do;
		%let element_length = 32;
		%end;

/*	%if &tot = 0 %then %do;*/
/*		*/
/*		%global &in_condition;*/
/*		%let in_condition = %nrstr((1=1));*/
/**/
/*	%end;*/

	%if &tot > 0 %then %do;

		%if %sysfunc(mod(&tot, 1000)) = 0 %then %do;

			proc sql;
				insert into list_elements (&var.)
				values 	(%if %upcase("&var_type") = "CHAR" %then %do; 'A' %end;
						 %if %upcase("&var_type") = "NUM" %then %do; 0 %end;);
			quit;

			%let tot = %eval(&tot + 1);

		%end;

		%let max_string_length = %eval((&tot * &element_length) + 2);
		%let lists = %eval(%sysfunc(floor(&tot/1000))+1);

		%let conditions	= %eval(%sysfunc(floor(&max_string_length./60000))+1);

		%if &lists. = 1 %then %do;

			%global in_condition;

			proc sql noprint;
				select &quotemark1.(&var.)&quotemark2 into :temp separated by ","
				from list_elements
				;
			quit;

			%let in_condition = &lookup_var. &clause1. (&temp.);
		%end;


		%if &lists. > 1 %then %do;


			%if &conditions. = 1 %then %do;

				%global in_condition;

				%do k = 1 %to &lists. %by 1;

					%let start = %eval((1000*(&k-1))+1);
					%let end = %sysfunc(min(%eval(&start+999),&tot.));

					%if &start <= &end %then %do;

						proc sql noprint;
							select &quotemark1.(&var.)&quotemark2 into :temp separated by ","
							from list_elements (firstobs = &start. obs = &end.)
							;
						quit;

						%if &k = 1 %then %do;
							%let in_condition = &lookup_var. &clause1. (&temp.);
						%end;

						%if &k > 1 %then %do;
							%let in_condition = &in_condition &clause2. &lookup_var. &clause1. (&temp.);
						%end;

					%end;

				%end;

				
			%end;


			%if &conditions. > 1 %then %do;

				%global in_condition;

				%let condlists = %sysfunc(ceil(&lists./&conditions.));

				%let yy = %eval(&conditions. - 1);
				%do y = 1 %to &yy. %by 1;

					%do z = 1 %to &condlists. %by 1;
						
						%let list_id = %eval((&condlists.*(&y.-1))+&z./*-1*/);
						%let start = %eval((1000*((&condlists.*(&y.-1))+&z.-1)+1));
						%let end = %sysfunc(min(%eval(&start+999),&tot.));

						%if &start <= &end %then %do;

							proc sql noprint;
								select &quotemark1.(&var.)&quotemark2 into :temp separated by ","
								from list_elements (firstobs = &start. obs = &end.)
								;
							quit;

							%global cond&list_id;
							%let cond&list_id = (&temp);

						%end;

					%end;

				%end;

				%let w = &conditions.;
				%let last_condlists = %eval(&lists. - (&condlists. * &yy.));


				%do v = 1 %to &last_condlists. %by 1;

					%let list_id = %eval((&condlists.*(&y.-1))+&v./*-1*/);
					%let start = %eval((1000*((&condlists.*(&y.-1))+&v.-1)+1));
					%let end = %sysfunc(min(%eval(&start+999),&tot.));

					%if &start <= &end %then %do;

						proc sql noprint;
							select &quotemark1.(&var.)&quotemark2 into :temp separated by ","
							from list_elements (firstobs = &start. obs = &end.)
							;
						quit;

						%global cond&list_id;
						%let cond&list_id = (&temp);

					%end;

				%end;

				%let in_condition = (%nrstr(&lookup_var) &clause1. %nrstr(&cond1);

				%do g = 2 %to %eval(&lists.-1) %by 1;
					%let in_condition = &in_condition &clause2. %nrstr(&lookup_var) &clause1. %nrstr(&cond)&g;
				%end;

				%let gg = &lists;
				
				%let in_condition = &in_condition &clause2. %nrstr(&lookup_var) &clause1. %nrstr(&cond)&gg);

			%end;

		%end;

		proc sql;
			drop table contents, list_elements
			%if %upcase("&drop_table") = "Y" %then %do;
				,&in_ds.
			%end;
			;
		quit;

	%end;

	%let in_condition = ( &in_condition. );


%mend;
