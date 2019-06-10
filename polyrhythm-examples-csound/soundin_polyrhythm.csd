<CsoundSynthesizer>
<CsOptions>

; Select audio/midi flags here according to platform
; Audio out   Audio in
-odac           -iadc   -B256 ;;;RT audio I/O

; change the path to your audio samples folder
--env:SSDIR+=/Users/georgboenn/Documents/wav/samples/

</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1

; Initialize the ZAK space.
; Create 2 a-rate variables and 2 k-rate variables.
zakinit 8, 8

; change the filenames if you want your own samples here:
gifil1     ftgen     1, 0, 0, 1, "bbc_soundfx/07063059.wav", 0, 0, 0
gifil1     ftgen     2, 0, 0, 1, "bbc_soundfx/07044052.wav", 0, 0, 0
gifil1     ftgen     3, 0, 0, 1, "sound/voice.wav", 0, 0, 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr inp, 100 ; choose between mono or stereo file

ichn filenchnls  p4	;check number of channels
;print  ichn

if ichn == 1 then	
asig   soundin p4	;mono signal
a1 zamod asig, -1
       outs    a1, a1
else			;stereo signal
aL, aR soundin p4
a1 zamod aL, -1
a2 zamod aR, -1
       outs    a1, a2
endif

zacl 8, 8

endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr loop, 101



ichnls = ftchnls(p4)
;print ichnls

if (ichnls == 1) then
   asigL loscil .8, 1, p4, 1, 1
   a1 zamod asigL, -1
   a2 zamod asigL, -2
   a3 zamod asigL, -3
   asigL  = 	a1+a2+a3
   asigR = asigL
elseif (ichnls == 2) then
   asigL, asigR loscil .8, 1, p4, 1, 1
   a1 zamod asigL, -1
   a2 zamod asigL, -2
   a3 zamod asigL, -3
   asigL  = 	a1+a2+a3
   a4 zamod asigR, -1
   a5 zamod asigR, -2
   a6 zamod asigR, -3
   asigR  = 	a4+a5+a6
;safety precaution if not mono or stereo
else
   asigL = 0
   asigR = 0
endif
        outs asigL, asigR

zacl 8, 8
endin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr gate1, 201

aEnv  transeg 0, p3/8, -5, 0.5*p4, p3*1/8, 0, 0.5*p4, p3*6/8, -3, 0
;	outs aEnv, aEnv
	zaw aEnv, 1
	
endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr gate2, 202

aEnv  transeg 0, p3/8, -5, 0.5*p4, p3*1/8, 0, 0.5*p4, p3*6/8, -3, 0
;	outs aEnv, aEnv
	zaw aEnv, 2
	
endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr gate3, 203

aEnv  transeg 0, p3/8, -5, 0.5*p4, p3*1/8, 0, 0.5*p4, p3*6/8, -3, 0
;	outs aEnv, aEnv
	zaw aEnv, 3
	
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
	;i "gate" 0 .5 1
		kresult = kresult | kcycle0
		event "i", "gate1", 0, 0.2, 1
	endif	
	if kcount % im2 == 0 then
		kresult = kresult | kcycle0
		event "i", "gate2", 0, 0.5, 1
	endif	
	if kcount % im3 == 0 then
		kresult = kresult | kcycle0
		event "i", "gate3", 0, 0.5, 1.
	endif	
	kcount = kcount + 1
	if kcount > ktotal then
		kcount = p5
	endif
endif

endin

</CsInstruments>
<CsScore>

;i "inp" 0 60 "sound/voice.wav"	;mono signal
;i "inp" 2 6 "sound/flute.wav"	;stereo signal
i "loop" 0 60 1	;mono signal
i "loop" 10 50 2	;mono signal
;i "gate" 0 .5 1
;i "gate" 1 .5 1
;i "gate" 2 .5 1

; n start dur tempo (bpm) cstart clength a:b:c
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
i "r_trio" 0 60 450 0 179 9 5 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;i "r_trio" 0 60 450 5 17 13 8 7
s .5
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
