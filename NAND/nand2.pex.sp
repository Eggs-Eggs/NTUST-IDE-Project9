* File: nand2.pex.sp
* Created: Fri May 19 18:24:38 2023
* Program "Calibre xRC"
* Version "v2021.3_35.19"
* 
.include "nand2.pex.sp.pex"
.subckt nand2  INPUT2 INPUT1 VDD! OUTPUT VSS!
.lib 'hspice.lib' tt

* VSS!	VSS!
* OUTPUT	OUTPUT
* VDD!	VDD!
* INPUT1	INPUT1
* INPUT2	INPUT2
MM0 N_OUTPUT_MM0_d N_INPUT2_MM0_g N_VDD!_MM0_s N_VDD!_MM0_b Pch L=1.8e-07
+ W=2e-06 AD=9.8e-13 AS=9.8e-13 PD=2.98e-06 PS=2.98e-06
MM1 N_OUTPUT_MM1_d N_INPUT1_MM1_g N_VDD!_MM1_s N_VDD!_MM0_b Pch L=1.8e-07
+ W=2e-06 AD=9.8e-13 AS=9.8e-13 PD=2.98e-06 PS=2.98e-06
MM3 N_NET17_MM3_d N_INPUT2_MM3_g N_VSS!_MM3_s N_VSS!_MM3_b Nch L=1.8e-07
+ W=1e-06 AD=4.9e-13 AS=4.9e-13 PD=1.98e-06 PS=1.98e-06
MM2 N_OUTPUT_MM2_d N_INPUT1_MM2_g N_NET17_MM2_s N_VSS!_MM3_b Nch L=1.8e-07
+ W=1e-06 AD=4.9e-13 AS=4.9e-13 PD=1.98e-06 PS=1.98e-06
*
.include "nand2.pex.sp.NAND2.pxi"
*
.ends
*
Xnand2 INPUT2 INPUT1 VDD! OUTPUT VSS! nand2

Vvdd vdd! 0 1.8
Vvss vss! 0 0
Vinput1 INPUT1 0 pulse (0 1.8 0 20p 20p 2n 4n)
Vinput2 INPUT2 0 pulse (0 1.8 0 20p 20p 3.98n 8n)
.option post
.trans 1p 20n

.meas TRAN Vmax MAX V(output) FROM=0n TO=10n
.meas TRAN Vmin MIN V(output) FROM=0n TO=10n

.meas TRAN Trise TRIG V(output) VAL='Vmin+0.1*Vmax' RISE=2  *** 量測rising time，此範例為電壓從"第二次達到最大電壓值的1成"上升到"第二次達到最大電壓值的9成"的時間，命名為Trise
+                TARG V(output) VAL='0.9*Vmax' RISE=2

.measure SlewRate param = '(Vmax*0.9 - Vmin - Vmax *0.1)/Trise'

.meas TRAN Tdelay_HL TRIG V(input1) VAL='0.5*Vmax' RISE=1    *** 量測 high-to-low switching time
+                    TARG V(output) VAL='0.5*Vmax' FALL=1

.meas TRAN Tdelay_LH TRIG V(input1) VAL='0.5*Vmax' FALL=1    *** 量測 low-to-high switching time
+                    TARG V(output) VAL='0.5*Vmax' RISE=1

.measure Propagation_Delay param = '(Tdelay_LH + Tdelay_HL)/2'

.END
