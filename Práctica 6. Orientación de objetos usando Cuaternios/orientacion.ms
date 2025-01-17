fn orientacion Base Traveler Plano Tinicio Tfin = (
	
	animate on for t in Tinicio to Tfin by 1 do (
		
		at time t (
			
			---------------------------------------------------------------------------------
			--  			C�lculo de la posici�n 										    --
			---------------------------------------------------------------------------------
			
			-- Modificaci�n de la posici�n del Traveler para que se mueva conforme
			-- a Base
			Traveler.pos.x = Base.pos.x
			Traveler.pos.y = Base.pos.y
			
			-- Creaci�n de un rayo
			if( Base.pos.z > Plano.pos.z ) then
			(
				Rayo = ray Base.pos [0,0,-1]
			) else 
			(
				Rayo = ray Base.pos [0,0,1]
			)
			
			-- Calculamos la colisi�n del rayo con el plano
			Colision = IntersectRay Plano Rayo
			
			-- Ajustamos la altura del Traveler en funci�n de la colisi�n del Rayo
			-- con el Plano
			-- Si queremos que vaya por encima del plano:
			Traveler.pos.z = Colision.pos.z + Traveler.radius
			-- Si queremos que vaya por debajo del plano:
			-- Traveler.pos.z = Colision.pos.z - Traveler.radius
			
			---------------------------------------------------------------------------------
			-- 			C�lculo de la rotaci�n										     --
			---------------------------------------------------------------------------------
			
			-- Vamos a calcular el vector director utilizando la posici�n del Traveler
			-- en el instante anterior
			posAntes = ( at time (t - 1) Traveler.pos )
			
			-- Obtenemos el vector restando la posici�n actual menos la anterior
			-- Para que rote en la direcci�n correcta por encima del plano:
			direccion = Traveler.pos - posAntes
			-- Para que rote en la direcci�n correcta por debajo del plano:
			--direccion = posAntes - Traveler.pos
			
			-- Para encontrar el eje de rotaci�n del Traveler, utilizamos el producto
			-- vectorial
			RotVector = cross direccion Colision.dir
			
			-- Calculamos el �ngulo de rotacion para ello necesitamos:
			-- Lo que avanza el Traveler en una vuelta completa:
			vuelta = Traveler.radius * 2 * pi
			-- La distancia que recorre el Traveler:
			distancia = Length direccion
			-- Hacemos el c�lculo
			distanciaporvuelta = distancia / vuelta
			-- Lo pasamos a grados, teniendo en cuenta que una vuelta son 360 grados
			RotAngle = 360 * distanciaporvuelta
			
			-- Calculamos el cuaternio
			Quaternion = quat RotAngle ( normalize RotVector )
			
			-- Utilizamos el cuaternio
			RotEuler = QuatToEuler Quaternion
			rotate Traveler RotEuler
			
		)
		
	)
	
)

rollout Interfaz "Orientaci�n"
(
	
	-- Elementos del actor base a imitar
	label EBase "Actor base: "
	button UI_Selector_Base "Selecciona el actor base"
	
	-- Elementos del actor que imita
	label ETraveler "Actor sobre plano: "
	button UI_Selector_Traveler "Selecciona el actor del plano"
	
	-- Elementos del plano sobre el que se realiza el recorrido
	label EPlano "Plano: "
	button UI_Selector_Plano "Selecciona el plano"
	
	-- Tiempos de ejecucion
	spinner UI_IF "Comienzo" range:[0,1000,0] type:#Integer
	spinner UI_FF "Fin" range:[0,1000,400] type:#Integer
	
	-- Bot�n para crear la animaci�n
	button UI_CrearAnimacion "Crear"
	
	-- Selector del actor base
	on UI_Selector_Base pressed do
	(
		seleccion = ( getCurrentSelection() as array )
		
		if( seleccion.count > 0 ) then
		(
			global Base = seleccion[1]
			UI_Selector_Base.text = Base.name
		)
		else
		(
			UI_Selector_Base.text = "Selecciona un objeto"
		)
	)
	
	-- Selector del actor imitador
	on UI_Selector_Traveler pressed do
	(
		seleccion = ( getCurrentSelection() as array )
		
		if( seleccion.count > 0 ) then
		(
			global Traveler = seleccion[1]
			UI_Selector_Traveler.text = Traveler.name
		)
		else
		(
			UI_Selector_Traveler.text = "Selecciona un objeto"
		)
	)
	
	-- Selector del plano
	on UI_Selector_Plano pressed do
	(
		seleccion = ( getCurrentSelection() as array )
		
		if( seleccion.count > 0 ) then
		(
			global Plano = seleccion[1]
			UI_Selector_Plano.text = Plano.name
		)
		else
		(
			UI_Selector_Plano.text = "Selecciona un objeto"
		)
	)
	
	-- Creaci�n de la animaci�n
	on UI_CrearAnimacion pressed do
	(
		if Base != undefined OR Traveler != undefined OR Plano != undefined OR UI_IF.value < UI_FF.value do
		(
			deletekeys Traveler
			Traveler.dir = [0,0,1]
			
			orientacion Base Traveler Plano UI_IF.value UI_FF.value
		)
	)
	
)

createDialog Interfaz