*********************** Replication codes for ************************
** "Monetary Policy Transmission in the United Kingdom:  *************
**      A High Frequency Identification Approach" 	 *************
********** by A. Cesa-Bianchi, G. Thwaites, and A. Vicondoa **********

**********************************************************************
To replicate the main results of the paper run "CTV_main.m". 
Select the Figure to replicate in lines 26-30.
The code reads from "CTV_DATA.xlsx".
The folder "Codes" includes all the relevant routines. Please make sure 
to add this folder (together with all subfolders) to your Matlab path 
before running "CTV_main.m". 
The code has been tested with Matlab R2018b.
To overidentification test is coded in Stata. To replicate the main
results of this test run "CTV_Overidtest.do" which calls the reduced
form residuals of the baseline VAR ("ReducedFormResiduals_Baseline.xls").
Please change replace the XYZ at the beginning of the do-file with
the directory where you store the files to run the code. 
**********************************************************************
January, 2020