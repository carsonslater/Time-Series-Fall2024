options linesize=75 center;
libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/Example/Time_series';
title 'Quarterly Beer Sales Data';

symbol1 i=none color=red v=star ;
symbol2 i=join v=none color=blue;
symbol3 i=join color=green v=none;

/*data ldata.a; set work.import; run;*/
data a; set ldata.beer; t=_n_; 
run;

* graph of the data;
proc sgplot data=a;
scatter y=beer x=t;
series y=beer x=t;
run;
proc means data=a min max median; run;
proc transreg data=a ; 
title2 'Defaults no graphs'; 
model boxcox(beer) = identity(t); 
run;

data b;set a;run;
* Fit Box-Cox model, output results to output data sets; 
ods output boxcox=b details=d; 
ods exclude boxcox; 

proc transreg details data=a; 
model boxcox(beer / convenient lambda=-2 to 2 by 0.01) = identity(t); 
output out=trans; 
run; 

* graph of transformed data;
proc sgplot data=trans;
scatter y=Tbeer x=t;
series y=Tbeer x=t;
run;


data c; set trans; keep Tbeer t; where t<200; run;

proc arima data=c;
*    i var=Tmin_temp(1, 12);
    i var=Tbeer(12) center;
*    i var=lz(1,12);
    e  p=3 q=(11,12) noint method=ml; *this line seems to reproduce Splus output;
    f back=104 lead=160 id=t out=out1 noprint;
	run;

proc sgplot data=out1;
 *  where t > 20;
   band Upper=u95 Lower=l95 x=t
      / LegendLabel="95% Confidence Limits";
   scatter x=t y=Tbeer;
   series x=t y=forecast;
run;

