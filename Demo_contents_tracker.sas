/*********************************************************************/
/* Program    :  Demo_contents_tracker.sas                           */
/* Description:  Demonstrate macros and tricks as outlined in the    */
/*               Data Quality presentation given on xx/xx/2018       */
/* Input      :  DQ macros, dummy data                               */
/* Output     :  Lst file with helpful information                   */
/* Note       :                                                      */
/*                                                                   */
/*********************************************************************/

* Libnames for use in demo;
libname testdata "C:\Users\mhudson\marias_projects\SAS_Contents_Tracker";

%include "C:\Users\mhudson\marias_projects\SAS_Contents_Tracker\Contents_Tracker.sas";

%prep_contents_tracker;

%update_contents_tracker(ds2check=testdata.states,note=States data as imported);

data states us (keep=state_code state_total_obs rename=(state_total_obs = tota));
  set testdata.states;
  if state_code = 'US' then output us;
  else output states;
run;

%update_contents_tracker(ds2check=states,note=States data without total);
%update_contents_tracker(ds2check=us,note=Total Only);

proc sort data=states nodupkey;  by state_code; run;

%update_contents_tracker(ds2check=states,note=States data de-duplicated);

data total_comp (keep=total);
  set states end=lastobs;
  if _n_ = 1 then total = 0;
  retain total;
  total = total + state_total_obs;
  if lastobs then output;
run;

%update_contents_tracker(ds2check=total_comp,note=States collapsed to total only);

%finalize_contents_tracker;
