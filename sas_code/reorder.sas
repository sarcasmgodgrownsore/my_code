

%macro reorder(in_dataset = , out_dataset = , in_vars = );

	%if "&out_dataset" = "" %then
	%do;
		data &in_dataset.;
	%end;
	%else
	%do;
		data &out_dataset.;
	%end;
			retain &in_vars.;
			set &in_dataset.;
		run;

%mend;
