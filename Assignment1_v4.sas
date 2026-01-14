/* Compare whether the hazard rate of different treatment types changes over time. */
/* input data */
proc import dbms=csv 
		datafile='/home/u64388585/LungCancer/data/Sweden_Lung_Cancer_500.csv' 
		out=lungdata replace;
run;

proc format;
	value trtfmt 0="Radiation" 1="Chemotherapy" 2="Surgery" 3="Combined";
run;

proc format;
	value smoking_statusfmt 0="Never" 1="Passive Smoke" 2="Former Smoke" 
		3="Current Smoker";
run;

proc format;
	value cens 0="Not Censored" 1="Censored";
run;

/* Task 1 */
/* group: treatment_type*/
data lungdata;
	set lungdata;
	label treatment_days="Time since treatment initiation (days)";
run;

proc lifetest data=lungdata plots=survival(cb);
	time treatment_days * survived(1);
	strata treatment_type;
	format treatment_type trtfmt.;
run;

/* Censoring plot*/
ods graphics / reset attrpriority=none;

proc sgplot data=lungdata;
	styleattrs datasymbols=(plus circle) datacolors=(black red);
	scatter x=treatment_days y=treatment_type / group=survived jitter;
	xaxis label="Time to event (days from treatment start)";
	yaxis values=(0 1 2 3) valuesdisplay=("Radiation" "Chemotherapy" "Surgery" 
		"Combined") label="Treatment group" min=-0.5 max=3.5;
	format survived cens. treatment_type trtfmt.;
	keylegend / title="";
run;

/* Task 2 */
/* KM survival -> KM cumulative hazard = -log(S(t)) */
proc lifetest data=lungdata method=km;
    time treatment_days * survived(1);
    strata treatment_type;
    ods output ProductLimitEstimates=km_pl;   /* contains Survival */
    format treatment_type trtfmt.;
run;

proc contents data=km_pl; run;

/* Compute KM cumulative hazard */
data km_cumhaz;
    set km_pl;

    /* Keep only time points where survival is defined */
    if survival > 0 then km_cumhaz = -log(survival);

    /* Some LIFETEST outputs have multiple rows per time; keep what you need */
run;

proc sgplot data=km_cumhaz;
    styleattrs datacontrastcolors=(orange purple blue)
               datalinepatterns=(solid shortdash mediumdash);

    step x=treatment_days y=km_cumhaz / group=treatment_type;

    title "Kaplan–Meier cumulative hazard: -log(S(t))";
    xaxis label="Time since treatment start (days)";
    yaxis label="Cumulative hazard (-log(S(t)))" grid;

    label treatment_type="Treatment Type";
    format treatment_type trtfmt.;
run;


/*N-A*/
/* proc lifetest data=lungdata method=breslow; */
/* 	time treatment_days * survived(1); */
/*  */
/* 	0=die, 1=survived(censored) */
/* 	strata treatment_type; */
/* 	ods output BreslowEstimates=lungdata_nelson; */
/* 	format treatment_type trtfmt.; */
/* run; */
/*  */
/* proc sgplot data=lungdata_nelson; */
/* 	styleattrs datacontrastcolors=(orange purple blue) datalinepatterns=(solid  */
/* 		shortdash mediumdash); */
/* 	step x=treatment_days y=cumhaz / group=treatment_type; */
/* 	title "Nelson-Aalen cumulative hazard"; */
/* 	xaxis label="Time since treatment start (days)"; */
/* 	yaxis label="Cumulative hazard" grid; */
/* 	label treatment_type="Treatment Type"; */
/* 	format treatment_type trtfmt.; */
/* run; */

/* Task 3 */
data lungdata_logtime;
	set lungdata;
	logtime=log(treatment_days);
run;

/* group: treatment_type*/
proc lifetest data=lungdata_logtime plots=survival(cb);
	time logtime * survived(1);

	/* 0=die, 1=survived(censored) */
	strata treatment_type;
	format treatment_type trtfmt.;
run;

/* Task 4 */
/* Stratify */
proc lifetest data=lungdata;
	time treatment_days * survived(1);
	strata smoking_status / group=treatment_type;
	format treatment_type trtfmt.;
	format smoking_status smoking_statusfmt.;
run;

/* Seperate by smoking_status  */
proc sort data=lungdata;
	by smoking_status;

proc lifetest data=lungdata;
	time treatment_days * survived(1);
	strata treatment_type;
	by smoking_status;
	format treatment_type trtfmt.
    format smoking_status smoking_statusfmt.;
run;