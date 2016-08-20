%MACRO LOGIT_CTS01(TRAIN, Y, Y_TYPE, X, ID, T, WEIGHTS, SEED, WD);
title3 "LOGIT_CTS01";
title4 "FITTING: LOGISTIC REGRESSION FOR CONTINUOUS OUTCOMES in (0,1)"; 
title5 "VARIABLE SELECTION: ALL";
%LET nX = %sysfunc(countw(&X));
data _temp;
 set &TRAIN;
 _ind = 1;
run;
proc logistic data=_temp;
 model &Y/_ind = &X;
 %IF &WEIGHTS ne %THEN %DO; weight &WEIGHTS; %END;
 ods output ParameterEstimates=_MyCoef;
run;
data _null_;
 set _MyCoef end=eof;
 file "&WD\f_LOGIT_CTS01.sas";
 if _n_ = 1 then put "p_LOGIT_CTS01 = 1/(1+exp(-1*(";
 if Variable="Intercept" then put Estimate;
 else put "+" Estimate "*" Variable ;
 if eof then put ")));" ;
run;
proc datasets lib=work; delete _: ; run; quit;
%MEND LOGIT_CTS01;