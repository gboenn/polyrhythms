<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in
-odac           -iadc   -B256 ;;;RT audio I/O

; change the path to your audio samples folder
--env:SSDIR+=/Users/georgboenn/Documents/wav/samples/

</CsOptions>
<CsInstruments>

; Initialize the global variables.
sr = 44100
ksmps = 1
nchnls = 2
0dbfs  = 1

;ir ftgen ifn, itime, isize, igen, iarga [, iargb ] [...
;f#  time  size  1  filcod  skiptime  format  channel 
;gifil1     ftgen     0, 0, 0, 1, "basic_crash2.wav", 0, 0, 0

; change the filenames if you want your own samples here:
gifil1     ftgen     1, 0, 0, 1, "basic/basic_crash2.wav", 0, 0, 0
gifil2     ftgen     2, 0, 0, 1, "basic/basic_crash_short2.wav", 0, 0, 0
gifil3     ftgen     3, 0, 0, 1, "basic/basic_crash_short.wav", 0, 0, 0
gifil4     ftgen     4, 0, 0, 1, "basic/basic_crash.wav", 0, 0, 0
gifil5     ftgen     5, 0, 0, 1, "basic/basic_hh_closed.wav", 0, 0, 0
gifil6     ftgen     6, 0, 0, 1, "basic/basic_hh_open.wav", 0, 0, 0
gifil7     ftgen     7, 0, 0, 1, "basic/basic_hihat.wav", 0, 0, 0
gifil8     ftgen     8, 0, 0, 1, "basic/basic_kick.wav", 0, 0, 0
gifil9     ftgen     9, 0, 0, 1, "basic/basic_kick2.wav", 0, 0, 0
gifil10     ftgen     10, 0, 0, 1, "basic/basic_kick3.wav", 0, 0, 0
gifil11     ftgen     11, 0, 0, 1, "basic/basic_kick_flam.wav", 0, 0, 0
gifil12     ftgen     12, 0, 0, 1, "basic/basic_ride_bell3.wav", 0, 0, 0
gifil13     ftgen     13, 0, 0, 1, "basic/basic_ride_flam_short.wav", 0, 0, 0
gifil14     ftgen     14, 0, 0, 1, "basic/basic_ride_short.wav", 0, 0, 0
gifil15     ftgen     15, 0, 0, 1, "basic/basic_ride.wav", 0, 0, 0
gifil16     ftgen     16, 0, 0, 1, "basic/basic_rim2.wav", 0, 0, 0
gifil17     ftgen     17, 0, 0, 1, "basic/basic_rim_bounce.wav", 0, 0, 0
gifil18     ftgen     18, 0, 0, 1, "basic/basic_rim.wav", 0, 0, 0
gifil19     ftgen     19, 0, 0, 1, "basic/basic_snare2.wav", 0, 0, 0
gifil20     ftgen     20, 0, 0, 1, "basic/basic_snare3.wav", 0, 0, 0
gifil21     ftgen     21, 0, 0, 1, "basic/basic_snare4.wav", 0, 0, 0
gifil22     ftgen     22, 0, 0, 1, "basic/basic_snare_bounce2.wav", 0, 0, 0
gifil23     ftgen     23, 0, 0, 1, "basic/basic_snare_bounce3.wav", 0, 0, 0
gifil24     ftgen     24, 0, 0, 1, "basic/basic_snare_bounce.wav", 0, 0, 0
gifil25     ftgen     25, 0, 0, 1, "basic/basic_snare_flam2.wav", 0, 0, 0
gifil26     ftgen     26, 0, 0, 1, "basic/basic_snare_flam.wav", 0, 0, 0
gifil27     ftgen     27, 0, 0, 1, "basic/basic_snare_roll.wav", 0, 0, 0
gifil28     ftgen     28, 0, 0, 1, "basic/basic_snare.wav", 0, 0, 0
gifil29     ftgen     29, 0, 0, 1, "basic/basic_tom2.wav", 0, 0, 0
gifil30     ftgen     30, 0, 0, 1, "basic/basic_tom3.wav", 0, 0, 0
gifil31     ftgen     31, 0, 0, 1, "basic/baisc_tom4.wav", 0, 0, 0
gifil32     ftgen     32, 0, 0, 1, "basic/basic_tom_flam2.wav", 0, 0, 0
gifil33     ftgen     33, 0, 0, 1, "basic/basic_tom_flam3.wav", 0, 0, 0
gifil34     ftgen     34, 0, 0, 1, "basic/basic_tom_flam.wav", 0, 0, 0
gifil35     ftgen     35, 0, 0, 1, "basic/basic_tom_floor.wav", 0, 0, 0
gifil36     ftgen     36, 0, 0, 1, "basic/basic_tom_short2.wav", 0, 0, 0
gifil37     ftgen     37, 0, 0, 1, "basic/basic_tom_short3.wav", 0, 0, 0
gifil38     ftgen     38, 0, 0, 1, "basic/basic_tom_short.wav", 0, 0, 0


; UDO bpmcurve

opcode bpmcurve, k, k
	kin xin
;	kout init 0.0                  
	kout = 100./tan(kin*0.017453292519943295) ; kin*pi/180.
	xout kout               ; write output
endop

instr bpm_ctrl
	kbpm init 0
	kbpm = bpmcurve(p4)
	chnset kbpm, "bpmval"
endin


; Instrument #1.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr 1, r1_2_3_5_7_11
; p4 tempo (bpm), p5 cstart, p6 clength

kresult init 0
kcycle0 init 1 << 0
kcycle1 init 1 << 1
kcycle2 init 1 << 2
kcycle3 init 1 << 3
kcycle4 init 1 << 4
kcycle5 init 1 << 5
kcycle6 init 1 << 6
 
ktempo init p4
;ktempo chnget "bpmval"

kcount init p5
ktotal init p5+p6

ktrig metro ktempo/60.
kamps2[] array 1., .7
kamps3[] array 1., .5, .3
kamps5[] array 1., .3, .5, .3, .2
kamps7[] array 1., .5, 0., 1., 0., 0., .5
if ktrig > 0 then
	kresult = 0
	if kcount % 1 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, kamps5[kcount % 5], 69.
	endif	
	if kcount % 2 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, kamps3[kcount % 3], 62.
	endif	
	if kcount % 3 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, 1., 8.
	endif	
	if kcount % 5 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, kamps7[kcount %7], 19.
	endif	
	if kcount % 7 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, kamps2[kcount %2], 30.
	endif	
	if kcount % 11 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, kamps2[kcount %2], 31.
	endif	
	kcount = kcount + 1
	if kcount > ktotal then
		kcount = p5
	endif
endif

endin

; Instrument #11.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr r6_7_11
; p4 tempo (bpm), p5 cstart, p6 clength

kresult init 0
kcycle0 init 1 << 0
kcycle1 init 1 << 1
kcycle2 init 1 << 2
kcycle3 init 1 << 3
kcycle4 init 1 << 4
kcycle5 init 1 << 5
kcycle6 init 1 << 6
 
ktempo init p4
;ktempo chnget "bpmval"

kcount init p5
ktotal init p5+p6

ktrig metro ktempo/60.
kamps2[] array 1., .7
kamps3[] array 1., .5, .3
kamps5[] array 1., .3, .5, .3, .2
kamps7[] array 1., .5, 0., 1., 0., 0., .5
if ktrig > 0 then
	kresult = 0
	if kcount % 6 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, kamps2[kcount % 2], 69.
	endif	
	if kcount % 7 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, kamps2[kcount % 2], 62.
	endif	
	if kcount % 11 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, 1., 8.
	endif	
	kcount = kcount + 1
	if kcount > ktotal then
		kcount = p5
	endif
endif

endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr r2_5_9
; p4 tempo (bpm), p5 cstart, p6 clength

kresult init 0
kcycle0 init 1 << 0
kcycle1 init 1 << 1
kcycle2 init 1 << 2
kcycle3 init 1 << 3
kcycle4 init 1 << 4
kcycle5 init 1 << 5
kcycle6 init 1 << 6
 
ktempo init p4
;ktempo chnget "bpmval"

kcount init p5
ktotal init p5+p6

ktrig metro ktempo/60.
kamps2[] array 1., .7
kamps3[] array 1., .5, .3
kamps5[] array 1., .3, .5, .3, .2
kamps7[] array 1., .5, 0., 1., 0., 0., .5
if ktrig > 0 then
	kresult = 0
	if kcount % 2 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, kamps2[kcount % 2], 69.
	endif	
	if kcount % 5 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, kamps2[kcount % 2], 62.
	endif	
	if kcount % 9 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, 1., 8.
	endif	
	kcount = kcount + 1
	if kcount > ktotal then
		kcount = p5
	endif
endif

endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr r_trio, 235
; p4 tempo (bpm), p5 cstart, p6 clength

kresult init 0
kcycle0 init 1 << 0
kcycle1 init 1 << 1
kcycle2 init 1 << 2
kcycle3 init 1 << 3
kcycle4 init 1 << 4
kcycle5 init 1 << 5
kcycle6 init 1 << 6
 
ktempo init p4
;ktempo chnget "bpmval"

kcount init p5
ktotal init p5+p6
im1 init p7
im2 init p8
im3 init p9
printks "%d : %d : %d", 1,im1,im2,im3
;printks "string", itime [, kval1] [, kval2] [...] "string", kval
ktrig metro ktempo/60.
kamps2[] array 1., .7
kamps3[] array 1., .5, .3
kamps5[] array 1., .3, .5, .3, .2
kamps7[] array 1., .5, 0., 1., 0., 0., .5
if ktrig > 0 then
	kresult = 0
	if kcount % im1 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, kamps2[kcount % 2], 69.
	endif	
	if kcount % im2 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, kamps2[kcount % 2], 62.
	endif	
	if kcount % im3 == 0 then
		kresult = kresult | kcycle0
		event "i", 3, 0, 0.5, 1., 8.
	endif	
	kcount = kcount + 1
	if kcount > ktotal then
		kcount = p5
	endif
endif

endin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr 3


;p4 = amplitude (0dbfs=1) p5 = pitch (midinote)
;map p5 to f-table number
;setup f-table numbers so they are easily mapped to midi notes (GM drum map)
;map p4 to loscil xamp

ipanL = 0.5
ipanR = 0.5
isamnum = p5  
if (isamnum == 69) then
	isamnum = 5
	ipanL = 0.7
	ipanR = 0.3
endif

if (isamnum == 62) then
	isamnum = 18
	ipanL = 0.6
	ipanR = 0.4
endif

if (isamnum == 57) then
	isamnum = 12 
	p3 = p3 * 2
	ipanL = 0.4
	ipanR = 0.6
endif

if (isamnum == 48) then
	isamnum = 9
endif

if (isamnum == 64) then
	isamnum = 8
endif

if (isamnum == 76) then
	isamnum = 29
endif

ichnls = ftchnls(isamnum)
;isam1 = gifil1
;print isamnum

kEnv transeg 0, p3/8, -5, 0.5*p4, p3*3/8, 0, 0.5*p4, p3*7/8, -3, 0
if (ichnls == 1) then
;ar1 [,ar2] loscil xamp, kcps, ifn [, ibas] ...
   asigL loscil p4, 1, isamnum, 1, 0
   asigR = 	asigL
elseif (ichnls == 2) then
   asigL, asigR loscil 1, 2, isamnum, 1, 0
else
   asigL = 0
   asigR = 0
endif
   outs asigL*kEnv*ipanL, asigR*kEnv*ipanR

endin
instr 990 ; write to a file (always on in order to record everything)
aSigL, aSigR    monitor                              ; read audio from output bus
        fout     "/tmp/polyr.wav",4,aSigL,aSigR   ; write audio to file (16bit mono)
endin
  
</CsInstruments>
<CsScore>

; n start dur tempo (bpm) cstart clength
;i 1 0 60 400 0 30

;18 = 11, 5, 2, mean: 6 sigma: 3.74166  Coprime pairs. Coprime sequence! Product: 110
;18 = 11, 4, 3, mean: 6 sigma: 3.55903  Coprime pairs. Coprime sequence! Product: 132
;19 = 11, 5, 3, mean: 6.33333 sigma: 3.39935 prime. Coprime pairs. Coprime sequence! Product: 165
   
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
i "r_trio" 0 10 400 0 20  3 5 7 ; 18 = 11, 5, 2, mean: 6 sigma: 3.74166  Coprime pairs. Coprime sequence! Product: 110
s .5     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
i "r_trio" 0 10 400 0 20 11 5 2 ; 18 = 11, 5, 2, mean: 6 sigma: 3.74166  Coprime pairs. Coprime sequence! Product: 110
s .5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
i "r_trio" 0 10 400 0 13 11 4 3 ; 18 = 11, 4, 3, mean: 6 sigma: 3.55903  Coprime pairs. Coprime sequence! Product: 132
s .5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
i "r_trio" 0 10 400 0 164 11 5 3 ; 19 = 11, 5, 3, mean: 6.33333 sigma: 3.39935 prime. Coprime pairs. Coprime sequence! Product: 165
s .5

;i "r_trio" 0 10 800 10 22 6 7 11

;i "r2_5_9" 0 60 400 45 89
;i 1 0 20 180 5 35
;i 990 0 60
e


</CsScore>
</CsoundSynthesizer>













<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
<EventPanel name="" tempo="60.00000000" loop="8.00000000" x="452" y="554" width="655" height="346" visible="false" loopStart="0" loopEnd="0">    </EventPanel>
