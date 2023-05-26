* File: INV.pex.sp
* Created: Thu May 18 02:33:26 2023
* Program "Calibre xRC"
* Version "v2021.3_35.19"
* 
.include "INV.pex.sp.pex"
.subckt INV  VSS! VDD! INPUT OUTPUT
.lib 'hspice.lib' tt
* 
* OUTPUT	OUTPUT
* INPUT	INPUT
* VDD!	VDD!
* VSS!	VSS!
MM1 N_OUTPUT_MM1_d N_INPUT_MM1_g N_VSS!_MM1_s N_VSS!_MM1_b Nch L=1.8e-07
+ W=1e-06 AD=4.9e-13 AS=4.9e-13 PD=1.98e-06 PS=1.98e-06
MM0 N_OUTPUT_MM0_d N_INPUT_MM0_g N_VDD!_MM0_s N_VDD!_MM0_b Pch L=1.8e-07
+ W=2e-06 AD=9.8e-13 AS=9.8e-13 PD=2.98e-06 PS=2.98e-06
*
.include "INV.pex.sp.INV.pxi"
*
.ends
*
XINV VSS! VDD! INPUT OUTPUT INV
Vvdd vdd! 0 1.8
Vvss vss! 0 0
Vinput input 0 pulse (0 1.8 0 20p 20p 2n 4n)
.option post
.trans 1p 20n

.meas TRAN Vmax MAX V(output) FROM=0n TO=10n    *** 一段時間內的電壓最大值，命名為Vmax
.meas TRAN Vmin MIN V(output) FROM=0n TO=10n    *** 一段時間內的電壓最小值，命名為Vmin

.meas TRAN Trise TRIG V(output) VAL='Vmin+0.1*Vmax' RISE=2
+                TARG V(output) VAL='0.9*Vmax' RISE=2

.meas TRAN Tfall TRIG V(output) VAL='0.9*Vmax' FALL=2
+                TARG V(output) VAL='Vmin+0.1*Vmax' FALL=2

.meas TRAN Tdelay_HL TRIG V(input) VAL='0.5*Vmax' RISE=1    *** 量測 high-to-low switching time
+                    TARG V(output) VAL='0.5*Vmax' FALL=1

.meas TRAN Tdelay_LH TRIG V(input) VAL='0.5*Vmax' FALL=1    *** 量測 low-to-high switching time
+                    TARG V(output) VAL='0.5*Vmax' RISE=1

.END
*
