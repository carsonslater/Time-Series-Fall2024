options linesize=75 pagesize=600 center;
title 'Wei Duke Energy Data';
title2 'Intervention Example';
data a; N=_N_;
input price @@;
datalines;
38.75	37.91	38.53	37.74	38.15	38.12	37.76	38.02	38.06	37.74
35.45	35.67	35.19	35.05	35.19	35.49	34.91	34.01	33.71	34.33
34.13	33.58	32.49	31.63	32.06	32.78	33.64	33.97	34.57	34.44
33.27	33.27	33.68	33.69	33.55	33.55	34.15	34.80	35.04	35.93	
36.24	36.43	37.24	36.68	35.87	35.68	35.52	34.93	34.91	34.98
35.66	35.78	35.19	37.75	37.73	37.30	36.79	37.32	37.52	37.22
37.67	37.47	38.26	38.22	38.91	38.80	38.86	38.37	38.21	37.18
36.92	38.32	37.82	37.74	38.05	38.60	38.73	37.72	36.92	37.84
38.04	37.58	37.32	37.22	36.74	36.06	36.12	36.21	35.98	36.03
36.69	36.19	34.70	33.52	34.35	34.19	35.01	35.34	34.70	34.59
33.51	31.78	32.01	30.70	31.70	31.32	30.68	30.00	29.09	29.12
30.13	31.00	31.01	31.71	32.92	32.83	31.00	31.76	31.66	31.70
31.29	30.84	31.10	30.36	30.00	29.75	30.30	30.31	29.06	26.00
27.95	24.75	23.70	22.26	22.42	20.72	19.95	19.30	19.00	22.07
22.54	22.45	22.40	24.93	25.49	25.44	24.26	24.13	25.00	25.75
26.09	26.33	26.71	26.62	27.75	26.63	27.51	27.55	28.36	28.00
27.10	27.86	26.76	27.29	27.25	26.83
;

data c; set a ; Int = (N >= 130); new = 2*Int + 22;
proc print;run;
*proc means;
symbol1 c=red i=join v=star;
symbol2 c=green v=plus;
symbol3 c=blue i=join v=none;
proc gplot; plot price*N=1 new*N=3 /overlay ;
run;

proc arima data=c;
/*  Look at the input series oil  */
    i var=price(1) noprint;
/*  Fit the model with b=0 r=0 s=1  */
	i var=price(1) crosscor=(Int(1)) noprint ;
    e      input=( (1 2 ) Int) noint ;
run;
   