extends Node

var paused = false

func _ready():
	if OS.is_debug_build():
		await get_tree().create_timer(0.5).timeout
		get_window().always_on_top = true
		



var flavor = "
#pig
img=[char]
name=[Crew]
recipe=[fuel->1s->fuse->1->{pigpois},organs->1s->fuse->1->{pig},cyber->10s->fuse->1->{strangepig}]
A member of the CREW. Can investigate LANDING SITES, FLOTSAM or WRECKAGE we find during our journey.

#strangepig
additionaltype=[pig]
img=[strange]
name=[Strange Crew]
countdown=[30->pigdead]
recipe=[fuel->1s->addtime->1->{30},bones->1s->addtime->1->{30},pig->1s->addtime->1->{30},organs->1s->addtime->1->{30},cyber->1s->addtime->1->{60},irons->1s->addtime->1->{30},log->1s->addtime->1->{30},pig->5s->addtime->1->{60},medicine->10s->fuse->1->{pig}]
They seem to work tirelessly with no sleep. Nor do they get injured or sick. We provide them with a constant source of nourishment but they still hunger for more. They will consume anything at all...\n\nSomething seems off with this member of our CREW... 

#pigexhaust
additionaltype=[exhaust,pig]
img=[charhurt]
name=[Crew (Exhausted)]
countdown=[10->pig]
recipe=[fuel->1s->fuse->1->{pigpois},organs->1s->fuse->1->{pig},medicine->1s->fuse->1->{pig},cyber->10s->fuse->1->{strangepig}]
We must wait to recover, otherwise the might overexhaust ourselves.

#pigpois
additionaltype=[pig,hurt]
img=[charhurt]
name=[Crew (Poisoned)]
countdown=[30->pigdead]
recipe=[fuel->1s->fuse->1->{pigdead},medicine->10s->fuse->1->{pig},cyber->10s->fuse->1->{strangepig}]
Poisoned. We must heal them with the use of MEDICINE or they will perish.

#pigbroken
additionaltype=[pig,hurt]
img=[charhurt]
name=[Crew (Hurt)]
countdown=[30->pigdead]
recipe=[fuel->1s->fuse->1->{pigdead},medicine->10s->fuse->1->{pig},cyber->10s->fuse->1->{strangepig}]
Injured. We must heal them with the use of MEDICINE or they will perish.

#pigdead
img=[chardead]
name=[Crew (Perished)]
countdown=[30->acdead]
recipe=[cyber->10s->fuse->1->{strangepig}]
...

#acdead
img=[chardead]
name=[Crew (Perished)]
countdown=[1->bones]
...

#ship
recipe=[fuel->3s->transform->1||1||1||1||2->{momentum},organs->5s->transform->1->{momentum},cyber->10s->transform->1->{unknown},bones->5s->transform->1->{momentum},pigdead->5s->transform->2->{momentum;momentum;momentum;unknown},strangepig->5s->transform->1->{unknown}]
This stolen freighter was once used to transport 'perishables'.

Place FUEL on this card to generate MOMENTUM. If there is no more FUEL we might be able to feed the engine something else.

#shipexhaust
additionaltype=[exhaust,ship]
img=[shiphurt]
name=[Ship (Superheated)]
countdown=[14->ship]
recipe=[fuel->3s->transform->2->{momentum},organs->5s->transform->1||2||2->{momentum},cyber->10s->transform->1->{unknown},bones->5s->transform->1||2->{momentum},pigdead->5s->transform->2->{momentum;momentum;momentum;unknown},strangepig->5s->transform->1->{unknown},irons->1s->fuse->1->{ship}]
The engines have overheated. If we add more fuel they might break. However in this superheated state they might also produce more MOMENTUM...

#shipbroken
additionaltype=[ship]
img=[shipbroke]
name=[Ship (Damaged)]
countdown=[30->acbroken]
recipe=[irons->8s->fuse->1->{ship}]
We will not survive without our SHIP. we must restore it with the use of IRONS before it is too late.

#acbroken
additionaltype=[ship]
img=[shipbroke]
name=[Shipwreck]
countdown=[1]
Our SHIP is lost... 

#momentum
img=[wayfinding]
countdown=[30]
We fling our bodies into the void.

Useful to reach different types of PLANETS or escape malignant celestial events...

#fuel
additionaltype=[consumable,fluid]
img=[wands]
countdown=[60]
We feed this to the SHIP.

#irons
img=[swords]
countdown=[40]
recipe=[organs->7s->fuse->1||1||1||1||1||1||1||1||2->{cyber}]
Scrap, alloys and other metallurgic matter. Can be used to repair the SHIP when needed.

#organs
img=[cups]
countdown=[20]
recipe=[irons->7s->fuse->1||1||1||1||1||1||1||1||2->{cyber},organs->5s->fuse->1->{medicine},bones->5s->fuse->1->{medicine},medicine->5s->fuse->1->{organs}]
Perishable, but useful in synthesizing medicine by combining with other organic matter.

#medicine
countdown=[60]
Can be used to cure the CREW's status effects.

#bones
img=[coins]
countdown=[40]
recipe=[organs->5s->fuse->1->{medicine},bones->5s->fuse->1->{medicine}]
Not much use for this... we might fire it in the SHIP's engines...

#cyber
name=[Strange Organs]
countdown=[30]
It somehow fused...

#unknown
name=[Unknown]
countdown=[30]
recipe=[organs->10s->fuse->5->{organs},fuel->10s->fuse->5->{fuel},irons->10s->fuse->5->{irons},bones->10s->fuse->5->{bones},pig->10s->fuse->1->{pigdead},medicine->10s->fuse->5->{medicine},momentum->10s->fuse->5->{momentum},cyber->10s->fuse->1->{researchindev}]
A strange residue we uncovered. It is of unknown use but occasionally twitches.

#researchindev
name=[Developing]
countdown=[20]
recipe=[strangepig->10s->mine->1->{altered},pig->10s->fuse->1->{altered}]
The strange MATTER has reacted with the tissue. It now seems to react to our presence... Should one of our CREW investigate?

#log
name=[Data Log]
A DATA LOG we deceivered. It reads...

#altered
name=[Resilient DNA]
Our DNA has fused with the MATTER, altering key nucleotides that make us immune from the SIGNAL's algorithm. We can now synthesize this DNA, making it available for all of our CREW.\n\nPlacing this card onto THE SIGNAL will remove the latter from play.

#sitea
name=[Landing Site]
countdown=[20]
recipe=[pig->5s->mine->1||2||2||3||3->{fuel;fuel;fuel;irons;irons;irons;irons;irons;organs;bones;organs;log}]
We discovered an area that might hold resources. Rich in metallic material and might contain hidden information.

Place a CREW here to salvage.

#siteb
name=[Landing Site]
countdown=[20]
recipe=[pig->5s->mine->1||2||2||3||3->{fuel;fuel;fuel;fuel;fuel;organs;irons;organs;irons;irons;organs;bones}]
We discovered an area that might hold resources. Rich in combustible material.

Place a CREW here to salvage.

#sitec
name=[Landing Site]
countdown=[20]
recipe=[pig->5s->mine->1||2||2||3||3->{fuel;fuel;irons;irons;fuel;irons;fuel;irons;organs;organs;organs;organs;irons;organs;bones;medicine}]
We discovered an area that might hold resources. Rich in organic material.

Place a CREW here to salvage.

#flotsam
name=[Flotsam Site]
countdown=[20]
recipe=[pig->5s->mine->1||2||2||2->{fuel;fuel;fuel;irons;irons;organs;organs;bones;medicine;log}]
Drifting in the void. Derelict cargo that could be of some use for us. Might be worth checking for logs.

Place a CREW here to salvage.

#vacuum
countdown=[10]
recipe=[momentum->2s->fuse->1->{fuel;irons}]
Space devoid of matter. Though tranquil, there is not much here. If we are desperate we might still try to explore with MOMENTUM.

#planet
name=[Planet]
countdown=[30]
recipe=[momentum->2s->fuse->2||3->{sitea;siteb;sitec;wreckage}]
A dot on the viewscreen. Large celestial body with many diverse resources.

We might explore here if we have MOMENTUM.

#planetoid
countdown=[25]
recipe=[momentum->2s->fuse->2->{sitea;siteb;sitec;wreckage;flotsam}]
A dot on the viewscreen. Small celestial body with diverse resources.

We might explore here if we have MOMENTUM.

#asteroid
countdown=[20]
recipe=[momentum->2s->fuse->1||2->{siteb;flotsam;irons;irons}]
A dot on the viewscreen. Heavy in metals but might also hold a few hidden salvage sites.

We might explore here if we have MOMENTUM.

#wreckage
name=[Wreckage Site]
countdown=[20]
recipe=[pig->5s->mine->1||2||2->{flotsam;flotsam;irons;irons;irons;organs;organs;bones;fuel;log;bones;medicine;log;log}]
Drifting in the void. The skeleton might hold some spare materials for our ship and crew. Perhaps even more in the cargo hold. Might be worth checking for logs.

Place a CREW here to salvage.

#origin
additionaltype=[planet]
img=[planet]
name=[Waning View]
countdown=[60]
recipe=[momentum->2s->fuse->1||2||2->{sitea;siteb;sitec}]
With this PLANET receding into the distance we feel elated but anxious.

Nothing immediate will happen once this card expires, but we might be able to salvage some resources with enough MOMENTUM.

#signal
name=[The Signal]
countdown=[60]
recipe=[momentum->1s->addtime->1->{25},altered->10s->signalsolved->1->{25}]
An encoded algorithm propagating towards us. If it reaches our ship it will evoke a kind of killswitch embedded within our CREW's DNA. We can only hope to outrun this now...

If this ticks to ZERO we will perish. We increase the timer by adding MOMENTUM. Or perhaps there is another way?

#goal
name=[Hospitable Planet]
countdown=[60]
recipe=[momentum->2s->endplanet->1->{25}]
We can approach the HOSPITABLE PLANET with MOMENTUM. But we have to make sure to eliminate the threat of the encroaching SIGNAL first, otherwise staying here would bring certain doom...

#xxxxxxxxxxxxxxxxxx
"
