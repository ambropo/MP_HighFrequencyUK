*** Replication file for "Monetary Policy Tranmission in the United Kingdom: a High Frequency Identification Approach"
*** Ambrogio Cesa-Bianchi, Gregory Thwaites and Alejandro Vicondoa
*** European Economic Review, January 2020


*** Overidentification test using the HF series and the narrative ones for the UK
clear all

** Set the current directory accordingly
cd "XYZ\CTV_Replication Files"

* Load the reduced form residuals and the proxy from the baseline specification
import excel "ReducedFormResiduals_Baseline.xls", sheet("Hoja1") firstrow

* for each reduced form residual
ivreg2 CPI (i_1YR = cm2 cloyne), first noconstant robust
ivreg2 Unemployment (i_1YR = cm2 cloyne), noconstant robust
ivreg2 FX (i_1YR = cm2 cloyne), noconstant robust
ivreg2 Corp_Spread (i_1YR = cm2 cloyne), noconstant robust
ivreg2 Mortg_Spread (i_1YR = cm2 cloyne), noconstant robust
ivreg2 US_BAA (i_1YR = cm2 cloyne), noconstant robust
