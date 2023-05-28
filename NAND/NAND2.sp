************************************************************************
* auCdl Netlist:
* 
* Library Name:  NAND2
* Top Cell Name: nand2
* View Name:     schematic
* Netlisted on:  May 19 14:06:33 2023
************************************************************************

*.BIPOLAR
*.RESI = 2000 
*.RESVAL
*.CAPVAL
*.DIOPERI
*.DIOAREA
*.EQUATION
*.SCALE METER
*.MEGA
.PARAM
.lib 'hspice.lib' tt
.GLOBAL vss!
+        vdd!

*.PIN vss!
*+    vdd!

************************************************************************
* Library Name: NAND2
* Cell Name:    nand2
* View Name:    schematic
************************************************************************

.SUBCKT nand2 input1 input2 output
*.PININFO input1:I input2:I output:O
MM1 output input1 vdd! vdd! Pch m=1 l=180.0n w=2.0u
MM0 output input2 vdd! vdd! Pch m=1 l=180.0n w=2.0u
MM3 net17 input2 vss! vss! Nch m=1 l=180.0n w=1.0u
MM2 output input1 net17 vss! Nch m=1 l=180.0n w=1.0u
.ENDS

XNAND2 input1 input2 output nand2

Vvdd vdd! 0 1.8
Vvss vss! 0 0
v1 input1 0 pulse (0 1.8 0n 20p 20p 2n 4n)
v2 input2 0 pulse (0 1.8 0n 20p 20p 3.98n 8n)

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
