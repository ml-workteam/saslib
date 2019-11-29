/* MisterPo 2018 alex@ekimenko.ru */

/* This is a framework for multiprocessing
 * in SAS base programm
 * running on the same machine
 */
 
options autosignon=yes sascmd="!sascmd -dmr";
 
/* path to yor program */
%global PRG_DIR;
%let PRG_DIR = c:\sas\prg; 
 
 
%macro Signon(process);
   filename L&process. "&PRG_DIR\&process..log";
   %put Process &process is been starting...;
   signon &process;
   %syslput process=&process/remote=&process;
   %syslput PRG_DIR=&PRG_DIR/remote=&process;
   %syslput workpath=%sysfunc(pathname(work))/remote=&process;
   /* your vars */
   %syslput somevar=&somevar/remote=&process;
   
   rsubmit process=&process wait=no cwait=no csysrputsync=yes log=L&process.;
     options fullstimer notes xmin;
     libname worklib "&workpath";
     %include "&PRG_DIR\macroses.sas";
     %put &process started.
     
   endrsubmit;
   rdisplay &process;
%mend;
 
%macro Rsubmit(process);
   %let fstime=%sysfunc(putn(%sysfunc(time()), time.));
   %put Rsubmit to process <&process>: &fstime;
   rsubmit process=&process wait=no cwait=no csysrputsync=yes log=L&process.;
     options compress=yes;
     %let fstime=%sysfunc(putn(%sysfunc(time()), time.));
     %put Rsubmit: &fstime;
%mend;


 