punto1 = box length:1 width:1 height:1 wireColor:blue pos:[-50,-50,0]
punto2 = box length:1 width:1 height:1 wireColor:blue pos:[50,-50,0]
punto3 = box length:1 width:1 height:1 wireColor:blue pos:[0,-50,0]
ball = sphere radius:10 wireColor:green

fn interpolacionLineal Traveler T CP1 CP2 =
(
	
	V = (CP2-CP1)
	return ( CP1 + ((normalize V)*(((length V)/100)*T)) )
	
)

fn interpolacionCuadratica Traveler T CP1 CP2 CP3 =
(
	
	V1 = interpolacionLineal Traveler t CP1 CP3
	V2 = interpolacionLineal Traveler t CP3 CP2
	return interpolacionLineal Traveler t V1 V2
	
)

animate on for t in 0 to 100 by 1 do
(
	at time t
	(
		$Sphere001.pos = interpolacionCuadratica $Sphere001 t $Box001.pos $Box002.pos $Box003.pos
	)
)