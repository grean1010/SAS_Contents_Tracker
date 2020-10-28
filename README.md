# SAS_Contents_Tracker
Macros to track dataset contents throughout a SAS program

## Motivation
In an effort to make the most of SAS proc contents and to make my lst file as useful as possible, I wrote some macros to create a running list of dataset contents that can be printed at the end of a program.  There is also a simple SAS program to demostrate how the tracker might be used.

## Contents of this repo
* **contents_tracker.sas**:  This is the SAS program that contains contents-tracking SAS macros described in this document.
* **demo_contents_tracker.sas**: This is simple SAS code to demonstrate how the macros can be used. It is provided for demonstration purposes.  Note that log and lst files are also provided.
* **states.sas7bdat**: This is a simple SAS dataset containing state abbreviations and a count variables. It is provided for demonstration purposes. 

## Macro descriptions and usage
* prep_contents_tracker
    * This macro pre-emptively deletes the dataset contents_tracker.
    * This is a best practice whenever you plan to use proc append.
* update_contents_tracker(ds2check=,note=)
    * This macro runs proc contents on the dataset specified in the macro variable ds2check
    * It keeps only the key dataset information (name, variable/observation counts, dates) and adds whatever note is specified in the note macro variable.
    * This information is added to the contents_tracker dataset using proc append.  Note that proc append will create the contents_tracker if it does not yet exist.
* finalize_contents_tracker
    * This macro got into the dataset contents_tracker dataset and adds labels and elapsed time variables.
    * It then prints the final contents_tracker dataset to the lst file.

## Where is this useful?
* Long-running programs that create many datasets along the way or that update one dataset many times
* You can track the dataset propoerties at key times to make sure that you are getting the results expected.
    * For example, if you de-duplicate the dataset you can run update_contents_tracker both before and after de-duplication to see if it performed as expected.
    * Another example, if you transpose the data you can check to see the the number of observations and variables swapped
    * The elapsed-time calculations can be very useful in identifying bottlenecks in the runtime. 
* I frequently copy the final printout from my lst file into an email to notify stakeholders that my code has completed running and provide them with basic information about the run.
* The downside to this is that you will not see results until your program completes.  
    * This is good for systems that are established and de-bugged. 
    * It can serve as documentation of a sucessful program run.
    * It is not ideal for programs that you are currently de-bugging as the printout will only happen if you reach the end of the code.