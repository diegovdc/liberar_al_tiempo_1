(  /*compile here to assign values*/
s.boot;
(
// rhythmicon-based instrument
SynthDef(\pluck,
	{ |amp=1, freq=60, toRhythm=0.05, pan=0, att=0.01, sus= 2, rel=0.01, gate=1, out=0|
	var sig, env;

		sig= Pluck.ar(Pulse.ar(freq*[0.25,1,0.5,2],0.2,amp),
/*rhythm*/			Impulse.kr(freq*toRhythm),
/*freq*/			freq.reciprocal, freq.reciprocal, 0.5, 0.3);
		sig= Mix(sig).fold(-0.9,0.9);
		sig= Pan2.ar(sig,pan);

		env= EnvGen.kr(Env([0,1,1,0],[att,sus,rel]),gate, doneAction:2);
//		env= EnvGen.kr(Env.adsr(att,0.01,0.5,rel),gate,doneAction:2);
		Out.ar(out, sig*env)
	}
).add

);

~fund= 36.midicps;

// saquen su partitura del cuarteto romantico !!
// mm    1,2, 3,4,    5,6,    7,8,  9,10, 11,12,  13,14,  15,16,17,18;
~freq1= [6,   6, (20/3), (15/2),    8,     9, (15/2), (15/2),    8];
~freq2= [5,   5, (16/3),      6,    6,     6,      6,      6,    6];
~freq3= [4,   4,      4,  (9/2),    4,(15/4),  (9/2),  (9/2),    4];
~freq4= [2,   2,  (8/3),  (8/3),(5/2),     3,  (8/3),  (8/3),(5/2)];

// si multiplicamos la fundamental por el número de ataques en un compás podemos averiguar cual es la frecuencia de cada unidad del ritmo armónico

~voice1= Pbind(\instrument, \pluck,
	\freq, Pseq(~fund*~freq1,inf),
	\toRhythm, 0.005,
	\dur,  2/(65.4*0.005),

	\sus,  Pfunc{|x| x.dur*1 },
		\amp, 1);

~voice2= Pbind(\instrument, \pluck,
	\freq, Pseq(~fund*~freq2,inf),
	\toRhythm, 0.005,
	\dur,  2/(65.4*0.005),

	\sus,  Pfunc{|x| x.dur*1 },
		\amp, 1);

~voice3= Pbind(\instrument, \pluck,
	\freq, Pseq(~fund*~freq3,inf),
	\toRhythm, 0.005,
	\dur,  2/(65.4*0.005),

	\sus,  Pfunc{|x| x.dur*1 },
		\amp, 1);

~voice4= Pbind(\instrument, \pluck,
	\freq, Pseq(~fund*~freq4,inf),
	\toRhythm, 0.005,
	\dur,  2/(65.4*0.005),

	\sus,  Pfunc{|x| x.dur*1 },
		\amp, 1);
);

// to hear the first 18 bars expressing the rhythmic values with their pitch analogy
Ppar([~voice1,~voice2,~voice3,~voice4], 1).play;



// which notes in each index?
~v1= (~fund*~freq1).cpsmidi;
~v1[0];

~v2= (~fund*~freq2).cpsmidi;
~v2[0];

~v3= (~fund*~freq3).cpsmidi;
~v3[0];

~v4= (~fund*~freq4).cpsmidi;
~v4[0];
