
(
// rhythmicon-based instrument with any form of synthesis you want!!
SynthDef(\instrumentHarmRhythm,
	{ |amp=1, freq=60, toRhythm=0.01, pan=0, att=0.001, attGate=0.01, sus= 2, rel=0.01, gate=1, modul=6|
	var sig, env;

		sig= SinOsc.ar(SinOsc.kr(freq.midicps*modul,0,freq.midicps/4, freq.midicps),0,amp);
		sig= sig*Decay2.kr(Impulse.kr(freq.midicps*toRhythm), att, 1.5);


//		env= EnvGen.kr(Env([0,1,1,0],[att,sus,rel]),gate, doneAction:2);
		env= EnvGen.kr(Env.adsr(attGate,0.01,0.5,rel),gate,doneAction:2);
		Out.ar(0, sig*env)
	}
).add

);


~synth= Synth(\instrumentHarmRhythm, [\freq, 60]);

~synth.set(\freq, 60, \toRhythm, 0.01, \modul, 5.5, \att, 0.1);


(
// rhythmicon-based instrument with any form of synthesis you want!!
SynthDef(\instrumentHarmRhythm,
	{ |amp=1, freq=60, toRhythm=0.01, pan=0, att=0.001, attGate=0.01, sus= 2, rel=1, relGate=0.01, gate=1, modul=6, out=0|
	var sig, env;
		// cambiar el primer sig por cualquier sonido que se quiera;
		sig= SinOsc.ar(SinOsc.ar(freq*modul,0,freq/4, freq),0,amp);
		sig= sig*Decay2.kr(Impulse.kr(freq*toRhythm), att, rel);


		env= EnvGen.kr(Env([0,1,1,0],[attGate,sus,relGate]),gate, doneAction:2);
//		env= EnvGen.kr(Env.adsr(attGate,0.01,0.5,rel),gate,doneAction:2);
		Out.ar([2,out], sig*env)
	}
).add

);



(
Pdef(\modFreqHarmRhythm,
	Pbind(\instrument, \instrumentHarmRhythm, \freq, Pseq([48,72,72,72,72,60,60,67,67,67],inf),
	\toRhythm, 0.01,   \amp, 0.6,
	\modul, Prand([2,3,4,5,6,7,8,9],inf),
		\dur, 1/(Pfunc{|i| (i.freq.midicps*i.toRhythm)*0.99999 }),
		\att, 0.01,        \sus, Pfunc{|i| i.dur*0.9999 }));
);


Pdef(\modFreqHarmRhythm).quant([8,0,0,0]);
Pdef(\modFreqHarmRhythm).play










