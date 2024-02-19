/* Log_Message						*/
/*							*/
/* Writes a banner message to the log window		*/

%macro log_message(message);

	%let len = %length(&msg);
	%let width = 75;
	%let lines = %eval(&len / &width);
	%let maxlines = %eval(&lines + 1);
	%let i = %eval(&width + 1);
	%let eline = %str(**                                                                                    **);
	%let fline = %str(****************************************************************************************);
	%let space = %str( );

	%put &fline;
	%put &eline;

	%if &len. < &width. %then
	%do;
		
	%end;
	%else
	%do;
		%let check = %substr(&msg, &i, 1);

		%do line_no = 1 %to &maxlines.;

			%if &line_no. < &maxlines. %then
			%do;

				%do %while("&check" ne "");
					%let i = %eval(&i - 1);
					%let check = %substr(&msg, &i , 1);
				%end;

				%let line&line_no = %substr(&msg, 1, &i - 1);

				%let pad = ;
				%do zi = 1 %to &width. + 9 - &i.;
					%let pad =&pad%str( );
				%end;

				%let writeln = ** &&&line&line_no.&pad.**;
				%put &writeln;

				%let msg = %substr(&msg, &i);
				%let check = yes;

				%let i = %eval(&width + 1);

			%end;
		%end;
	%end;

	%let pad = ;
	%do zi = 1 %to &width. + 9 - %length(&msg) - 1;
		%let pad =&pad%str( );
	%end;

	%let writeln = ** &msg.&pad.**;
	%put &writeln;
	%put &eline;
	%put &fline;

%mend;




/* Countobs						*/
/*							*/
/* Creates a macro variable &obscount with the number	*/
/* of observations in the specified dataset		*/

%macro countobs(in_ds);

	%global obscount;

	%if %sysfunc(exist(&in_ds.)) or 
	%sysfunc(fileexist(&in_ds.)) %then
	%do;
		proc sql noprint;
  			select count(*) into :obscount
     			from &in_ds.
		quit;
	%end;


%mend countobs;





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




%macro drop_table(ds_list = , msg = n);

	%let i = 1;

	%do %until (%scan(&ds_list,&i,' ')=%str( )) ;

	   	%let ds = %scan(&ds_list,&i,' ');

		%if %sysfunc(exist(&ds)) %then
	    %do;
	    	proc sql;
				drop table &ds.;
	        quit;

			%log_message(Table &ds. has been dropped);

		%end;

		%let i = %eval(&i + 1);

	%end;

%mend drop_table;


%macro start_timer;

	%global s_time;

	data _null_;
		call symput('s_time', time());
	run;

%mend;




%macro end_timer;

	%global e_time;

	data _null_;
		call symput('e_time', time());
		call symput('end_time', ' End Time ' || strip(put(time(), time18.)));
		call symput('start_time', 'Start Time ' || strip(put(&s_time., time18.)));
	run;

	data _null_;
		if &s_time. < &e_time. then	diff = ' Time Taken ' || strip(put(&e_time. - &s_time., time18.));
		else diff = ' Time Taken ' || strip(put(&s_time. - &e_time. + '24:00't, time18.));

		put '****************************************************************************************';
		put '**                                                                                    **';
		put "** &start_time &end_time " diff;
		put '**                                                                                    **';
		put '****************************************************************************************';
	run;

%mend;




%macro quarter_dates(override_date = , /* Format is ddmmmyyyy */
                   
                    );

    %log_message(Getting quarter dates);

    %global start_dt rec_start_dt end_dt outcome_dt sas_start_dt sas_rec_start_dt sas_end_dt
            beh_start_dt beh_rec_start_dt sas_outcome_dt yrmth sas_beh_start_dt sas_beh_rec_start_dt
            rec_monyy aged_monyy aged_start_qtr_dt aged_end_qtr_dt rec_start_qtr_dt rec_end_qtr_dt
            aged_qtr rec_qtr;

    data _null_;

        today = today();

        %if "&override_date" ne "" %then
        %do;
            today = "&override_date"d;
        %end;

        yy = year(today);

        if month(today) in (1,2,3) then
        do;
            yy = year(today) - 1;
            mm = 12;
            dd = 31;
        end;
        else if month(today) in (4,5,6) then
        do;
            mm = 3;
            dd = 31;
        end;
        else if month(today) in (7,8,9) then
        do;
            mm = 6;
            dd = 30;
        end;
        else if month(today) in (10,11,12) then
        do;
            mm = 9;
            dd = 30;
        end;

        dmy = mdy(mm,dd,yy);

        sd = cats("'",put(intnx('month', dmy, -24, 'sameday') + 1,yymmddn8.),"'");
        aqtr = put(intnx('month', dmy, -12, 'sameday') ,yymmn6.);
        rqtr = put(intnx('month', dmy, 0, 'sameday') ,yymmn6.);
        asq = cats("'",put(intnx('month', dmy, -14) ,yymmddn8.),"'");
        aeq = cats("'",put(intnx('month', dmy, -12, 'sameday') ,yymmddn8.),"'");
        rsq = cats("'",put(intnx('month', dmy, -2) ,yymmddn8.),"'");
        req = cats("'",put(intnx('month', dmy, 0, 'sameday') ,yymmddn8.),"'");
        rec_start = cats("'",put(intnx('month', dmy, -12, 'sameday') + 1,yymmddn8.),"'");
        ed = cats("'",put(intnx('month', dmy, -12, 'sameday'),yymmddn8.),"'");
        od = cats("'",put(dmy,yymmddn8.),"'");
        beh_start = cats("'",put(intnx('month', dmy, -72, 'sameday') + 1,yymmddn8.),"'");
        beh_rec_start = cats("'",put(intnx('month', dmy, -60, 'sameday') + 1,yymmddn8.),"'");

        sas_sd = cats("'",put(intnx('month', dmy, -24, 'sameday') + 1,date9.),"'d");
        sas_rsd = cats("'",put(intnx('month', dmy, -12, 'sameday') + 1,date9.),"'d");
        sas_ed = cats("'",put(intnx('month', dmy, -12, 'sameday'),date9.),"'d");
        sas_od = cats("'",put(dmy,date9.),"'d");
        sas_bsd = cats("'",put(intnx('month', dmy, -72, 'sameday') + 1,date9.),"'d");
        sas_brsd = cats("'",put(intnx('month', dmy, -60, 'sameday') + 1,date9.),"'d");

        aged_monyy = put(intnx('month', dmy, -12, 'sameday'),monyy5.);
        rec_monyy = put(dmy,monyy5.);

        yrmth = put(dmy, yymmn6.);

        call symput('start_dt',sd);
        call symput('aged_qtr',aqtr);
        call symput('rec_qtr',rqtr);
        call symput('aged_start_qtr_dt',asq);
        call symput('aged_end_qtr_dt',aeq);
        call symput('rec_start_qtr_dt',rsq);
        call symput('rec_end_qtr_dt',req);
        call symput('rec_start_dt',rec_start);
        call symput('end_dt',ed);
        call symput('outcome_dt',od);
        call symput('beh_start_dt',beh_start);
        call symput('beh_rec_start_dt',beh_rec_start);

        call symput('sas_start_dt',sas_sd);
        call symput('sas_rec_start_dt',sas_rsd);
        call symput('sas_end_dt',sas_ed);
        call symput('sas_outcome_dt',sas_od);
        call symput('sas_beh_start_dt',sas_bsd);
        call symput('sas_beh_rec_start_dt',sas_brsd);

        call symput('aged_monyy',aged_monyy);
        call symput('rec_monyy',rec_monyy);

        call symput('yrmth',yrmth);

        put today=date9.;
    run;

    %put start_dt &start_dt;
    %put aged_qtr &aged_qtr;
    %put rec_qtr &rec_qtr;
    %put aged_start_qtr_dt &aged_start_qtr_dt;
    %put aged_end_qtr_dt &aged_end_qtr_dt;
    %put rec_start_qtr_dt &rec_start_qtr_dt;
    %put rec_end_qtr_dt &rec_end_qtr_dt;
    %put rec_start_dt &rec_start_dt;
    %put end_dt &end_dt;
    %put outcome_dt &outcome_dt;
    %put sas_start_dt &sas_start_dt;
    %put sas_rec_start_dt &sas_rec_start_dt;
    %put sas_end_dt &sas_end_dt;
    %put sas_outcome_dt &sas_outcome_dt;
    %put aged_monyy &aged_monyy.;
    %put rec_monyy &rec_monyy.;
    %put yrmth &yrmth;
    %put beh_start_dt &beh_start_dt;
    %put beh_rec_start_dt &beh_rec_start_dt;
    %put sas_beh_start_dt &sas_beh_start_dt;
    %put sas_beh_rec_start_dt &sas_beh_rec_start_dt;

    %log_message(Finished quarter dates);

%mend;





%macro reorder_vars(in_dataset = , out_dataset = , in_vars = );

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




%macro reset_titles;
	
	%do i = 1 %to %10;
		title&i;
	%end;

%mend;




%macro send_email(to = , cc = , from = , subject = , attach = , message = );

	%log_message(~Running send_email);

	filename mail email to = (&to.) 
						%if "&cc" ne "" %then
						%do;
							cc = (&cc.)
						%end;
 						from = "&from"
 						emailsys = smtp 
 						subject = "&subject"
						%if "&attach" ne "" %then
						%do;
							attach = ("&attach")
						%end;
						;

	data _null_;
		file mail;

		put "&message";
	run;

	%log_message(~Finished send_email);

%mend;


%macro show_macro_names;

title 'Current user-defined macros';
proc sql;
  select '%'||strip(lowcase(objname)) as MACRO_NAME
  		,created as DATE_CREATED
    from dictionary.catalogs
    where objtype='MACRO'
	and memname = 'SASMAC1'
/*	and created > intck('second', time(), -1)*/
	order by DATE_CREATED DESC, MACRO_NAME;
quit;
title;


%mend;




%macro show_macro_vars;

	proc sql;
		create table macro_vars as
		select scope
			   ,'&' || name label = 'Macro Name' as macro_name
			   ,value
		from   sashelp.vmacro
		order by scope, macro_name;
	quit;

	proc print data = macro_vars noobs label;
		by scope;
	run;

/*	%drop_table(macro_vars)*/

%mend;



%macro sleep(seconds);

	data _null_;
		x = sleep(&seconds);
	run;

%mend;



%macro split_dups(in_ds, out_ds, by_var) ;

	%log_message(~Running split_dups);

	%global max_loop split_count;

	%let temp_obs = 1;
	%let max_loop = 0;

	data temp_sd;
		set &in_ds.;
	run;

	proc sort data=temp_sd ;
		by &by_var.;
	run;
	
	%do %while (&temp_obs. > 0);

		%let max_loop = %eval(&max_loop + 1);
		%let split_count = 0;

		%drop_table(&out_ds._&max_loop.);

		data temp_sd(drop=c) &out_ds._&max_loop.(drop=c);
			set temp_sd end=eof;
			by &by_var.;

			if _n_ = 1 then c = 0;

			if first.&by_var. then
			do;
				c + 1;
				output &out_ds._&max_loop.;
			end;
			else output temp_sd;

			if eof then call symput('split_count',strip(c));
		run;

		%log_message(The dataset &out_ds._&max_loop. has &split_count. rows);
		%countobs(temp_sd);

		%let temp_obs = &obscount;

	%end;

	%drop_table(temp_sd);

	%log_message(max_loop is &max_loop);
	%log_message(&max_loop datasets created);
	%log_message(~Finished split_dups);

%mend;





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





%macro test_print(dataset = &syslast. /* The dataset to be printed. Default is the last dataset created. */ ,
				  no_records = 100  /* The sample size. Default is 100 */,
				  vars = _ALL_); /* The variables to be printed, seperated by spaces. Leave blank for all variables */

	%countobs(&dataset)

	%if &no_records >= &obscount %then %do;
		%let records = &obscount;
		%let display = All records;

		data temp;
			set &dataset.;
		run;

	%end;

	%else %do;
		%let records = &no_records;
		%let display = Sample of &records records;

		proc surveyselect data = &dataset.
						  method = srs 
						  n = &records.
						  out = temp noprint;
		run;


	%end;


	%let var_statement = %str( );
	%if &vars ne "" %then
	%do;
		%let var_statement = var &vars.%str(;);
	%end;

/*	ods listing close;*/
/*	ods markup file="c:\temp\a.html" style = styles.minimal;*/

		proc print data = temp noobs label;
			title "&display. from dataset &dataset.";
			&var_statement.
		run; title;

/*	ods markup close;*/
/*	ods listing;*/
/**/
/*	%drop_table(temp)*/

%mend;





%macro var_length (dataset = &syslast.);
* calculate varibale names and column width;
data vars;
   length name $20. type $1.;
   drop dsid i num rc;
   dsid=open("&dataset","i");
   num=attrn(dsid,"nvars");
   do i=1 to num;
      name=varname(dsid,i);
      type=vartype(dsid,i);
      length=varlen(dsid,i);
      output;
   end;
   rc=close(dsid);
run;

* create macro variable for total number of columns and column names;
data _null_;
call symput("num",trim(left(attrn(open("&dataset","i"),"nvars"))));
run;

data _null_;
* column names;
do i=1 to &num;
call symput("name"||trim(left(i)),varname(open("&dataset","i"),i));
end;
run;

* rename columns to standard name for use in array;
data temp;
set &dataset;
%do i=1 %to &num;
rename &&name&i=var&i;
%end;
run;

* calculate length of every cell;
data temp (keep=lenvar1-lenvar&num);
set temp;
%do i=1 %to &num;
lenvar&i=length(var&i);
%end;
run;

* calculate maximum length of every variable;
%do i=1 %to &num;
proc sql;
	create table len&i as
	select max(lenvar&i) as len&i 
	from temp;
quit;
run;
%end;

* set all column widths back together;
data lens;
%do i=1 %to &num;
set len&i;
%end;
run;

proc transpose data=lens out=lens;
run;

* output final variable width comparison;
data vars (drop=_name_);
merge vars lens (rename=(col1=maxlen));
if maxlen = length then trunc='Y';
label maxlen="Max Variable Length" trunc="Possible Truncation";
run;

* clean up datasets;
proc datasets library=work;
 	delete len1-len&num temp;
quit;

proc print data=vars label ;
label length="Column Width" maxlen="Max Variable Length" trunc="Possible Truncation";
title "Check Variable Length for &dataset";
run;
%mend;






%macro varlist(in_ds =  , /* Full name of input dataset, */
				out_ds =  , /* Name of output dataset containing variable list, */
				sort_by =  , /* Name of variable attribute to sort output dataset */
				);

	/* Find all the dataset attributes. */
	proc contents data = &in_ds. out = &out_ds. 
		(keep = name type length format label varnum) noprint;
	run;

	/* If a sort parameter is supplied then sort by this parameter. */
	%if "&sort_by" ne "" %then
	%do;
		proc sort data = &out_ds.;
		    by &sort_by.;
		run;
	%end;

	/* Create a format for the variable type. */
	proc format;
	    value vartype
	    1 = 'Numeric'
	    2 = 'Character'
		;
	run;


		proc print data = &out_ds. noobs;
			var varnum name label type length format ;
		    format type vartype.;
		    title "Variables contained in dataset '&in_ds.'";
		run;

	title;

%mend varlist;





%macro check_location(location =  ,	msg = n	);

	options noxwait;

	%let rc = %sysfunc(filename(fileref,&location));

	%if %sysfunc(fexist(&fileref)) %then
	%do;
		%if %upcase("&msg") = "Y" %then
		%do;
			%log_message(The directory &dir. already exists.);
		%end;
	%end;
	%else
	%do;
		%log_message(The directory &dir. does not exist.);
		%sysexec md &dir;
		%log_message(The directory &dir. has been created.);
	%end;

%mend;


























