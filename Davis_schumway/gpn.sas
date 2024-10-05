options pagesize=600 ls=80 center nodate;
title 'GNP Data';
 legend1 position=(bottom left inside)
           across=1 cborder=red offset=(0,0)
           shape=symbol(3,1) label=none
           value=(height=.8);
   symbol1 c=green v=- h=1;
   symbol2 c=red;
   symbol3 c=blue;
   symbol4 c=blue;
   data sasuser.gnp;n=_n_;
   input value @@;
   datalines;
 6.96272 6.96904 6.97270 6.98472 6.99099 7.00860 7.01778 7.02598 7.01428
 7.00841 7.01598 7.00606 7.04595 7.07412 7.11094 7.13903 7.15976 7.18569
 7.20771 7.21229 7.22198 7.21957 7.22853 7.24907 7.26641 7.27580 7.27115
 7.26305 7.24907 7.24508 7.25700 7.27156 7.29275 7.30364 7.31688 7.32561
 7.32363 7.32817 7.32890 7.33993 7.34814 7.34756 7.35340 7.33778 7.31728 
 7.32264 7.34601 7.36941 7.38175 7.40062 7.39603 7.40452 7.42154 7.41866
 7.41962 7.41101 7.42136 7.43373 7.44793 7.47017 7.48319 7.49354 7.50279 
 7.50114 7.51458 7.52833 7.54565 7.55281 7.57492 7.58345 7.59347 7.59775
 7.61918 7.63356 7.64936 7.67211 7.69170 7.69430 7.70450 7.70940 7.71503
 7.72099 7.73530 7.74093 7.75246 7.76934 7.77708 7.77612 7.79008 7.79144
 7.79696 7.79297 7.78680 7.78593 7.79803 7.78896 7.81545 7.81537 7.82048
 7.82044 7.84212 7.86138 7.87173 7.89032 7.91352 7.91608 7.91509 7.92400
 7.91841 7.92125 7.90813 7.89930 7.87956 7.88968 7.90651 7.92034 7.93894
 7.94339 7.94754 7.95746 7.97109 7.98708 8.00697 8.00440 8.01318 8.04427
 8.05281 8.06514 8.06517 8.06423 8.07322 8.07131 8.08129 8.05738 8.05804
 8.07066 8.08982 8.08647 8.09089 8.07683 8.06161 8.06460 8.05659 8.05811
 8.06671 8.08896 8.10361 8.12121 8.14662 8.15995 8.16639 8.17053 8.18242
 8.18847 8.19858 8.20587 8.22178 8.21733 8.21943 8.22513 8.23780 8.24808
 8.25814 8.27403 8.28657 8.29550 8.30204 8.30877 8.31769 8.32171 8.32596
 8.32681 8.33101 8.33209 8.33567 8.33168 8.32518
   ;
   run;
data a; set sasuser.gnp;run;
      
   
   title "Heteroscedastic Autocorrelated Time Series";
   proc gplot data=a;
      symbol1 v=dot i=join;
      symbol2 v=none i=join;
      plot value * n = 1 value * n = 2 / overlay;
   run;
   proc arima data=a;
   i var=value;
   run;

 proc autoreg data=a;
      model value = n / nlag=2 archtest dwprob;
      output out=r r=yresid;
   run;
*Heteroscedastic and GARCH Models;
   title2 'Heteroscedastic and GARCH Models';
    proc autoreg data=a;
      model value = n / nlag=2 garch=(q=1) maxit=50;
      output out=out cev=vhat;
   run;
 data out;
      set out;
      shat = sqrt( vhat );
   run;
   
   title2 "Predicted and Actual Standard Deviations";
   proc gplot data=out;
      plot shat*n=1 shat*n=2 / overlay;
      symbol1 v=dot  i=none;
      symbol2 v=none i = join;
   run;
