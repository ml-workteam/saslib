%macro cls;
	%put CLS;
%mend;	

/* SORTING */
%macro Sorting(InData, Var);
	proc sort data=&InData NOEQUALS;
		by &Var;
	run;	
%mend;

%macro NoDup(InData, ByVar);
	proc sort data=&InData out=&InData nodup;
		by &ByVar;
	%mend;	
%mend;

%macro NoDupKey(InData, ByVar, OutData);
	proc sort data=&InData out=&InData nodupkey;
		by &ByVar;
	run;	
%mend;

%macro DelFile(InData);
	proc datasets nolist mt=data mt=view mt=access;
		delete &InData;
	quit;	
%mend;

/* MERGING */
%macro Merging(MeData1, MeData2, ByVar, OutData);
	%Sorting(&MeData1,&ByVar);
	%Sorting(&MeData2,&ByVar);
	data &OutData;
		merge &MeData1 &MeData2;
		by &ByVar;
	run;
%mend;

%macro MergeIn(MeData1, MeData2, ByVar, OutData);
	%Sorting(&MeData1,&ByVar);
	%Sorting(&MeData2,&ByVar);
	data &OutData;
		merge &MeData1(in=InOne) &MeData2;
		by &ByVar;
		if InOne;	
	run;
%mend;

%macro MergeNot(MeData1, MeData2, ByVar, OutData);
	%Sorting(&MeData1,&ByVar);
	%Sorting(&MeData2,&ByVar);
	data &OutData;
		merge &MeData1 (in=InOne) &MeData2;
		if not InOne;
		by &ByVar;
	run;
%mend;

%macro Merge12(MeData1, MeData2, ByVar, OutData);
	%Sorting(&MeData1,&ByVar);
	%Sorting(&MeData2,&ByVar);
	data &OutData;
		merge &MeData1(in=InOne) &MeData2(in=InTwo);
		by &ByVar;
		if InOne;
		if InTwo;
	run;
%mend;
