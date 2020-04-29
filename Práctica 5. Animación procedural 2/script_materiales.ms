-- Este script simula unos cubos que caen en unas piscinas con pinturas
-- de distintos colores, por lo que cuando las traspasan, cambian su
-- color al de la piscina correspondiente

-- Creación de Materiales
mm = multimaterial numsubs:3 name:"Color"
mm.names = #("white", "red", "blue")
mm[1].diffuse = mm[1].ambient = white
mm[2].diffuse = mm[2].ambient = red
mm[3].diffuse = mm[3].ambient = blue

-- Creación de los Objetos
x = -30
y = 30
z = 30
for i = 1 to 5 do
	Box pos:[x + 10 * i, y - 10 * i, 30] \
	name:("caja_" + i as string)\
	length:5 width:5 height:5

-- Creacion del Array de Box
cajas = $caja* as array
cajas.mat = mm

-- Añade un modificador para cambiar el índice de submaterial a cada objeto
for obj in cajas do (
	addModifier obj( materialModifier name:"MatMod" )
		obj.modifiers[#MatMod].materialID = 1
)

-- Creación de las piscinas
x = 0
y = 0
z = 20
for i = 1 to 2 do
	box pos:[x, y, z - i * 20]\
	name:("piscina_" + i as string)\
	length:100 width:100 height:5

-- Creación del Array de Piscinas
piscinas = $piscina* as array
piscinas[1].mat = mm[2]
piscinas[2].mat = mm[3]

fn interpolacionLineal Traveler T CP1 CP2 =
(
	
	V = (CP2-CP1)
	return ( CP1 + ((normalize V)*(((length V)/100)*T)) )
	
)

-- Animacion de las cajas
animate on for t = 5 to 45 by 1 do
(
	for obj in cajas do
	(
		at time t
		(
			obj.pos.z = obj.pos.z - 2
		
			if( obj.pos.z > piscinas[1].pos.z ) then
			(
				obj.modifiers[#MatMod].materialID = 1
			)
			else if( obj.pos.z  < piscinas[1].pos.z And obj.pos.z > piscinas[2].pos.z ) then
			(
				obj.modifiers[#MatMod].materialID = 2
			)
			else if( obj.pos.z < piscinas[2].pos.z ) then
			(
				obj.modifiers[#MatMod].materialID = 3
			)
		)
	
	)
)