# One continuous18s Game1 rules observation (no game dispatch)

Same audio-only BIT/HWH,Codecprofile,original DMA/lease/pool checks andstartup
20ms/PLL25ms improvements. Reusesverifiedoriginaldescriptions/cleanstart and
identicalcaptureallocation/cleanupfunctionexceptduration/filename. Oneactual
18s continuous900packet epoch, not concatenated2s clips. Samebounded4/8CPU
queues,15mspoll,5mshealth,50msservicegap. Noactivecaptureprints orpromptIO.
CPUchildticksGame1policyonactualdecisionmonotonicclockeveryprocessedpacket,
logsrequested/suppressedattacks,shieldstart/refresh/expiry. Logsprintedafter
confirmedDMAstop; NO actions sent to game,HDMI,camera or boardoutputregisters.
Frameclockandactualgameactionlatency remainunverified. Observercopy ofpolicy
hash/bytescheckedagainstlocalconfirmed0.5scooldown/5sshieldimplementation.

Runonlyifearliersessionreleasedbuffers/owner,sameoverlay/Codecstillloaded,
nootherrecording. UploadwholeZIPextracttonewvoice_rule_session_20261012.
ReadtimelineFIRST; usewatch/phoneelapsedtimer, but do notplayaudio cues into
microphone. No sound should be spoken beforeLIVE_READY. OnfaultSTOP,no retry/
reload/kernelrestart. Sendfulloutput. No automatic recovery orcontinuousloop.

```python
%run /home/xilinx/jupyter_notebooks/voice_rule_session_20261012/run_live_voice_test.py --rules-18s --reset-audio-dma-before-record --cpu-worker --poll-budget-ms 15 --optimize-receive --pin-cpu --energy-onset-candidate --control-budget --pll-budget
```

Seconds approximatelyafterLIVE_READY:
0.5shortah;0.9shortah(cooldownprobe);1.8shortah(aftercooldown).
3.0..4.5sustainedoh;5.0shortah(shieldprobe).
6.0..7.5sustainedoh(newcommandafterrelease,refresh5s).
9.0shortah(stillshieldedafteroriginaldeadline).
13.0shortah(afterrefresheddeadline);14..18quiet.
Oh shouldbeone sustainedtone, not spokenword; normalvoice,no shouting.

Expected900packets/864000samples, originalsafe stop/buffers/ownerreleased,
rulelogs showingrequestedattackbefore/aftercooldown andaftershieldexpiry,
suppressedattackduringcooldownandshield,2acceptedohstarts(secondrefresh),
shieldexpiry5safterlastacceptedoh atfirstsubsequentworker tick. Actualtiming
isCPUdecisionclock, not soundonset or gameframe. Failedrecognition meanscase
NOT exercised; zero blockcounts MUST NOT be presentedasrulePASS. Expected
rules do not require arbitraryrapidah recognizer recall. Summary andrawrows
areevidenceforreview,recognition/gamepermission/latencyflagsremainfalse.
WAV savedasrules_18s_<uuid>.wav inexistingaudio-onlycapturedirectory.

Important: Oh detector'sstrict32window500ms acceptance remainsunchanged and
hasone knownfed64miss(longestvalidrun27windows). Ruleobserverdoesnotfixit.
Ifnoohaccepted,the5s/refreshcasesareunexercised, notsuccess. No thresholds
loosened bythispackage. Fixedgame2/camera/game3scope unchanged.
