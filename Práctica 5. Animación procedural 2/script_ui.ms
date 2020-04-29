global Puntos = $Box* as array

fn interpolacionLineal Traveler T CP1 CP2 TSalto =
(
	
	V = (CP2-CP1)
	return ( CP1 + ((normalize V)*(((length V)/TSalto)*T)) )
	
)

fn interpolacionCuadratica Traveler T CP1 CP2 CP3 TSalto =
(
	
	V1 = interpolacionLineal Traveler t CP1 CP2 TSalto
	V2 = interpolacionLineal Traveler t CP2 CP3 TSalto
	return interpolacionLineal Traveler t V1 V2 TSalto
	
)

fn calcularPuntoMedio CP1 CP2 =
(
	
	dist = distance CP1 CP2
	
	return [CP1.pos.x - (CP1.pos.x + CP2.pos.x)/2, CP1.pos.y-(CP1.pos.y + CP2.pos.y)/2, dist]
	
)

fn SquashAndStretch Traveler TSalto tinicio tfin FactorSquashStretch =
(
	
	tcambio = TSalto / 10
	zsquash = 1 - FactorSquashStretch
	zstretch = 1 + FactorSquashStretch
	
	animate on
	(
		at time( tinicio )
		(
			Traveler.scale = [1,1,zsquash]
		)
		
		at time( tinicio + 2 * tcambio )
		(
			Traveler.scale = [1,1,1]
		)
		
		at time( tinicio + 5 * tcambio )
		(
			Traveler.scale = [1,1,zstretch]
		)
		
		at time( tinicio + 8 * tcambio )
		(
			Traveler.scale = [1,1,1]
		)
		
		at time( tfin )
		(
			Traveler.scale = [1,1,zsquash]
		)
	)
	
)

fn volverEstadoOriginal Traveler t =
(
	
	animate on
	(
		at time( t )
		(
			Traveler.scale = [1,1,1]
		)
	)
	
)

fn rotarObjeto Traveler PInit PFin =
(
	
	dir = PFin.pos - PInit.pos
	vec = Traveler.transform[1]
	
	tm = Traveler.transform
	vec = normalize vec
	dir = normalize dir
	
	rtm = angleaxis ( acos( dot vec dir ) ) ( normalize ( cross dir vec ) )
	
	Traveler.transform = translate ( rotate (scalematrix tm.scale ) ( tm.rotation * rtm ) ) tm.pos
	
)

fn animacion Traveler TInicio TSalto FactorSquashStretch Puntos =
(
	
	tamanio = Puntos.count
	
	for i = 1 to (tamanio - 1) by 1 do
	(
		
		inicio = Puntos[i]
		fin = Puntos[i + 1]
		medio = calcularPuntoMedio inicio fin

		iniciofase = TInicio + (i - 1) * TSalto
		siguientefase = iniciofase + TSalto
		
		animate on for f in iniciofase to siguientefase by 1 do
		(
			at time f
			(
				rotarObjeto Traveler inicio fin
				t = f - iniciofase
				Traveler.pos = interpolacionCuadratica Traveler t inicio.pos Medio fin.pos TSalto
				SquashAndStretch Traveler Tsalto iniciofase siguientefase FactorSquashStretch
			)
		)
		
	)
	
	tvuelta = TSalto * ( tamanio - 1 ) + 5
	
	volverEstadoOriginal Traveler tvuelta
	
)

rollout Saltos "Saltos"
(

	label EActor "Actor:"
	button UI_SelectorActor "Selecciona Actor"
	label EPuntos "Puntos:"
	button UI_SelectorPuntos "Selecciona los puntos de salto"

	spinner UI_IF "Comienzo" range:[0,1000,0] type:#Integer
	spinner UI_TF "Tiempo/salto" range:[5,100,25] type:#Integer
	spinner UI_SS "Coeficiente Squash-Stretch" range:[0,1,0.5] type:#Float
	
	button UI_CrearSaltos "Animación"

	on UI_SelectorActor pressed do
	(
		seleccion = ( getCurrentSelection() as array )
		
		if( seleccion.count > 0 ) then
		(
			global Traveler = seleccion[1]
			UI_SelectorActor.text = Traveler.name
		)
		else
		(
			UI_SelectorActor.text = "Selecciona un objeto"
		)
	)
	
	on UI_SelectorPuntos pressed do
	(

		seleccion= ( getCurrentSelection() as array) 
		
		if( seleccion.count > 0 ) then
		(
			global Puntos = #()
			
			for obj in seleccion do
			(
				append Puntos obj
			)
			
			UI_SelectorPuntos.text = "Objetos seleccionados"
		)
		
	)
	
	on UI_SelectorPuntos picked obj do
	(
		global Puntos = (obj as array)
		UI_SelectorPuntos.text = "Puntos seleccionados"
	)
	
	on UI_CrearSaltos pressed do
	(
		if Traveler != undefined And Puntos != undefined do
		(
			deletekeys Traveler
			Traveler.pos = Puntos[1].pos
			Traveler.dir = [0,0,1]
			Traveler.showtrajectory = on
			animacion  Traveler  UI_IF.value  UI_TF.value  UI_SS.value  Puntos
		)
	)

)

createDialog Saltos width:300