/*********************************************************************/
/* Program    :  Contents_Tracker.sas                                */
/* Description:  Creates a macro that will keep track of datasets    */
/*               created throughout a program.                       */
/* Input      :  None                                                */
/* Output     :  dataset contents_tracker                            */
/* Note       :  Meant to be used as an include file.                */
/*                                                                   */
/*********************************************************************/

%macro prep_contents_tracker;

  * Delete the dataset that we will append to;
  * This is a precautionary step.;
  proc datasets lib=work nolist;
    delete contents_tracker;
    quit;
  run;

%mend prep_contents_tracker;

%macro update_contents_tracker(ds2check=,note=);

  * Run proc contents and only output to a dataset;
  proc contents data=&ds2check noprint out=c;
  run;

  * Sort to have the highest variable number first;
  proc sort data=c; by descending varnum; run;

  * Keep only one observation with only the information;
  * we will retain on the contents_tracker dataset;
  data c (keep=libname memname nobs varnum crdate modate note);
    set c (obs=1);
    format note $75.;
    note = "&note";
  run;

  * Append onto the contents_tracker dataset;
  proc append data=c base=contents_tracker;
  run;

  * Remove the temporary dataset from the work directory to;
  * prevent accidentally using it to describe another dataset;
  proc datasets lib=work nolist;
    delete c;
    quit;
  run;

%mend update_contents_tracker;

%macro finalize_contents_tracker;

  * Create measures of elapsed time in the contents tracker;
  data contents_tracker;
    set contents_tracker;
    elapsed_time_minutes = (crdate - lag(crdate)) / 60;
    elapsed_time_hours = elapsed_time_minutes / 60;
    elapsed_time_days = elapsed_time_hours / 24;
    label libname = "Library Name"
          memname = "Dataset Name"
          varnum = "Number of Variables"
          nobs = "Number of Observations"
          crdate = "Date Created"
          modate = "Date Modified"
          note = "Note"
          elapsed_time_minutes = "Elapsed Time (minutes)"
          elapsed_time_hours = "Elapsed Time (hours)"
          elapsed_time_days = "Elapsed Time (days)";
  run;

  * Print the dataset;
  title "Summary of Datasets Throughout Program";
  proc print data=contents_tracker noobs label;
  run;
  title;

%mend finalize_contents_tracker;
