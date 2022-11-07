%macro export_split (dsn=, size=);
    %*Get number of records and calculate the number of files needed;
    data _null_;
        set &dsn. nobs=_nobs;
        call symputx('nrecs', _nobs);
        n_files=ceil(_nobs/ &size.);
        call symputx('nfiles', n_files);
        stop;
    run;

    %*Set the start and end of data set to get first data set;
    %let first=1;
    %let last=&size.;
    
    %*Loop to split files;
    %do i=1 %to &nfiles;
    
        %*Split file by number of records;
        proc export data= &dsn. (firstobs=&first obs=&last) outfile="/home/u62160406/Nowy folder/nowy_&i.xlsx" dbms=xlsx;
        run;

        %*Increment counters to have correct first/last;
        %let first = %eval(&last+1);
        %let last = %eval((&i. + 1)*&size.);
    %end;
%mend export;

%export_split(dsn=sashelp.cars, size=50);