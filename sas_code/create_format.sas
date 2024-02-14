


%macro create_format(in_ds = , in_var = , format_name = , decimal_places = 0, library = work);

/*	%countobs(&in_ds.);*/

	proc sql noprint;
		select count(*) into :obscount
		from &in_ds.
		;
	quit;

	%let groups = &obscount.;
	%let nosort = S;

	proc transpose data=&in_ds. out=fmt_ds(drop=_name_) prefix=pos;
		var &in_var.;
	run;

	data fmt_ds(drop=pos: i rename=(start1=start end1=end) label='fred');
		fmtname = "&format_name";
		type = 'n';

		attrib label length=$20;
		set fmt_ds;

		array pos(%eval(&groups. + 2));

		do i = 1 to %eval(&groups. + 2);

			if i = 1 then hlo="&nosort ";
			else if i = 2 then hlo="&nosort.L";
			else if i = %eval(&groups. + 2) then hlo="&nosort.H";
			else hlo = "&nosort ";

			order = i;

			if i = 1 then
			do;
				start1 = .;
				end1 = .;
				label = 'Missing';
				sexcl = 'N';
				eexcl = 'N';
			end;
			else if i = 2 then
			do;
				start1 = .;
				end1 = pos1;
				label = end1;
				sexcl = 'N';
				eexcl = 'N';
			end;
			else if i = %eval(&groups. + 2) then
			do;
				start1 = pos(i - 2);
				end1 = .;
				label = put(pos(i - 2) + 10 ** (-&decimal_places.),10.&decimal_places.);
				sexcl = 'Y';
				eexcl = 'N';
			end;
			else
			do;
				start1 = pos(i - 2);
				end1 = pos(i - 1);
				label = end1;
				sexcl = 'Y';
				eexcl = 'N';
			end;

			output;
		end;

	run;

	data fmt_ds;
		set fmt_ds;
		label = strip(label);
	run;

	proc format library=&library. cntlin=fmt_ds;
   	run;

%mend;



