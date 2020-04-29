ball1 = sphere radius:10 wireColor:green
animate on
(
	at time 0 ball1.pos = [-100,0,0]
	at time 5 ball1.pos = [-100,0,0]
	at time 95 ball1.pos = [100,0,0]
)

ball2 = sphere radius:10 wireColor:green
animate on
(
	at time 0 ball2.pos = [-100,-100,0]
	at time 5 ball2.pos = [-100,-100,0]
	at time 95 ball2.pos = [100,100,0]
)

box1 = box length:5 width:5 height:5 wireColor:red
animate on for t in 0 to 100 by 1 do
	at time t
	(
		box1.pos = (ball2.pos + ball1.pos)/2
	)