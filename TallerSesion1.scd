s.boot;

// el ritmo armónico se plantea en el libro de Henry Cowell 'New musical resources' donde el desarrollo de las alturas, la armonía y el ritmo se plantea.

// Se llama ritmo armónico porque reproduce el patrón que se encuentra en la serie de parciales (conocida como serie de armónicos) en la que una frecuencia fundamental multiplicada por números enteros produce relaciones armónicas mientras que las relaciones con números flotantes producen relaciones inarmónicas; Por ejemplo:

// relaciones armónicas;
16.do{|i| {Pan2.ar(SinOsc.ar((100*(i+1)).postln, 0, (i+1).reciprocal*0.1), 0)}.play};


// relaciones inarmónicas;
16.do{ {Pan2.ar(SinOsc.ar(rrand(100,1600).postln, 0, (1/16)*0.5), 0)}.play};


// Cuando desaceleramos una señal de audio por debajo del umbral de modulación (20 hertz) esta no produce sonido pero sigue produciendo movimiento;

// si usamos pulsos de ruido y los aceleramos pasado el umbral de modulación tendremos una frecuencia audible;

// Ojo:    Protocolo midi a hertz:  60.midicps

// sonido (la altura que se genera es Do central (en protocolo midi 60= Do, 62= Re, etc))
{Impulse.ar(60.midicps, mul:0.1)!2}.play;

~toPulse= 0.5;
{Impulse.ar(60.midicps*~toPulse, mul:0.1)!2}.play;
{Impulse.ar(60.midicps*~toPulse/2, mul:0.1)!2}.play;
{Impulse.ar(60.midicps*~toPulse/4, mul:0.1)!2}.play;
{Impulse.ar(60.midicps*~toPulse/8, mul:0.1)!2}.play;
{Impulse.ar(60.midicps*~toPulse/16, mul:0.1)!2}.play;
{Impulse.ar(60.midicps*~toPulse/32, mul:0.1)!2}.play;
{Impulse.ar(60.midicps*~toPulse/64, mul:0.1)!2}.play;

~toPulse= ~toPulse/64;
// pulsos
{Impulse.ar(60.midicps*~toPulse, mul:0.9)!2}.play;

// la altura generada por el primer Impulse tiene un análogo en pulsos rítmicos;

// de esta manera podemos crear una equivalencia entre relaciones armónicas de alturas y relaciones armónicas rítmicas;

// una quinta, armónico 2 y 3;
{Splay.ar(Impulse.ar([60,67].midicps, mul:0.1))}.play;

// una quinta en ritmo armónico;
{Splay.ar(Impulse.ar([60,67].midicps*~toPulse, mul:0.5))}.play;

// qué relación rítmica este intervalo genera?


// una tercera mayor, armónico 4 y 5; En lugar de protocolo midi asignamos una fundamental de forma arbitraria en este caso 80 htz 80*4 (cuarto parcial de la columna de armónicos), 80*5 (quinto parcial de la columna de armónicos)
{Splay.ar(Impulse.ar([80*4,80*5], mul:0.1))}.play;

// una tercera mayor en ritmo armónico;
{FreqShift.ar(Impulse.ar([80*4,80*5]*~toPulse,0, [0.5,0.5]),[300,1000])}.play;

// qué relación rítmica este intervalo genera?




// acordes ;

// un acorde mayor;
{Splay.ar(Impulse.ar([80*8,80*12,80*10], mul:0.05))}.play;

// un acorde mayor en ritmo armónico;
{Splay.ar(Impulse.ar([80*8,80*12,80*10]*~toPulse*0.5, mul:0.5))}.play;

//  8:12:10

// un acorde mayor en ritmo armónico (voicing más complejo);
{Splay.ar(Impulse.ar([80*16,80*10,80*24]*~toPulse*0.25, mul:0.5))}.play;

{Impulse.ar([80*16,80*10,80*24]*~toPulse*0.25, mul:0.5)}.play;



// Pluck karlplus-strong synthesis;

{Pluck.ar(WhiteNoise.ar,Impulse.kr(1), (80*8).reciprocal, (80*8).reciprocal)}.play;




// harmonic rhythm;

(

SynthDef(\pluck,
	{ |amp=1, freq=60, toRhythm=0.05, pan=0, att=0.01, sus= 2, rel=0.01, gate=1|
	var sig, env;

		sig= Pluck.ar(Pulse.ar(freq*[0.25,1,0.5,2],0.2,amp),
/*rhythm*/			Impulse.kr(freq*toRhythm),
/*freq*/			freq.reciprocal, freq.reciprocal, 0.5, 0.3);
		sig= Mix(sig).fold(-0.9,0.9);
		sig= Pan2.ar(sig,pan);

		env= EnvGen.kr(Env([0,1,1,0],[att,sus,rel]),gate, doneAction:2);
//		env= EnvGen.kr(Env.adsr(att,0.01,0.5,rel),gate,doneAction:2);
		Out.ar(0, sig*env)
	}
).add

);

~synth=Synth(\pluck);

~synth.set(\gate, 0);


/* Traducir de duración a frecuencia
1/2   ==  2  (primero se divide 1 entre 2 0.5 * x = 1  osease  1/0.5)
1/3   ==  3  (0.66667 * x = 1  osease  1/(1/3))
1/4   ==  4
1/5   ==  5

1/freq   (proceso inverso: recíproco de la freq es su duración en segundos)
*/

//    a jugar!!!


(
Pdef(\a,
Pbind(\instrument, \pluck,
	\freq, Pseq([48,60,72,76,55].midicps,inf),
	\toRhythm, 0.01,
		\dur,  (1/(Pkey(\freq)*Pkey(\toRhythm)))*Pseq([2,4,8,10,3],inf),

	\sus,  Pfunc{|x| x.dur*1 },
		\amp, 1
)
)
);


(
Pdef(\a).quant_(0);
Pdef(\a).play;
);


(
Pdef(\a).stop;
);






(
Pdef(\b,
Pbind(\instrument, \pluck,
	\freq, Pseq([48,60,72,76,55].midicps*0.5,inf),
	\toRhythm, 0.01,
		\dur,  (1/(Pkey(\freq)*Pkey(\toRhythm)))*Pseq([2,4,8,10,3],inf),

	\sus,  Pfunc{|x| x.dur*1 },
	\amp, 1
)
);
)


(
Pdef(\a).quant_(0);
Pdef(\a).play;

Pdef(\b).quant_(0);
Pdef(\b).play;
);

(
Pdef(\a).stop;
Pdef(\b).stop;
);










