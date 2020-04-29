ball1 = sphere radius:10 wireColor:blue
animate on
(
	at time 0 ball1.pos = [-100,0,0]
	at time 5 ball1.pos = [-100,0,0]
	at time 55 ball1.pos = [100,0,0]
)

ball2 = sphere radius:10 wireColor:red
animate on
(
	at time 0 ball2.pos = [0,-100,0]
	at time 55 ball2.pos = [0,-100,0]
	at time 105 ball2.pos = [0,100,0]
)