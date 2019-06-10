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
gifil1     ftgen     1, 0, 0, 1, "bbc_soundfx/07063059.wav", 0, 0, 0
gifil1     ftgen     2, 0, 0, 1, "bbc_soundfx/07044052.wav", 0, 0, 0
gifil1     ftgen     3, 0, 0, 1, "sound/voice.wav", 0, 0, 0


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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

instr file_trio, 236
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
		event "i", 4, 0, 1, kamps2[kcount % 2], 3, 1, 1.5, 1.2
	endif	
	if kcount % im2 == 0 then
		kresult = kresult | kcycle0
		event "i", 4, 0, 1, kamps2[kcount % 2], 3, 0, .5, .8
	endif	
	if kcount % im3 == 0 then
		kresult = kresult | kcycle0
		event "i", 4, 0, 1, 2, 3, 1.5, 1.8, 1
	endif	
	kcount = kcount + 1
	if kcount > ktotal then
		kcount = p5
	endif
endif

endin

;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 4 ; flooper2
; p4 amp - p5 tablenr = p6 start (sec) - p7 end (sec) - p8 pitch
;kst  line     .2, p3, 2 ;vary loopstartpoint
;asig1[,asig2] flooper2 kamp, kpitch, kloopstart, kloopend, kcrossfade, ifn \
;      [, istart, imode, ifenv, iskip] 
kEnv transeg 0, p3/8, -5, 0.5*p4, p3*3/8, 0, 0.5*p4, p3*7/8, -3, 0

aoutL, aoutR flooper2 p4, p8, p6, p7, .05, p5 
     outs     aoutL*kEnv, aoutR*kEnv

endin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr 990 ; write to a file (always on in order to record everything)
aSigL, aSigR    monitor                              ; read audio from output bus
        fout     "/tmp/polyr.wav",4,aSigL,aSigR   ; write audio to file (16bit mono)
endin
  
</CsInstruments>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
<CsScore>

; n start dur tempo (bpm) cstart clength a:b:c
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
i "file_trio" 0 10 200 0 31 2 6 8
s .5

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
<EventPanel name="" tempo="60.00000000" loop="8.00000000" x="452" y="554" width="655" height="346" visible="true" loopStart="0" loopEnd="0">    </EventPanel>
