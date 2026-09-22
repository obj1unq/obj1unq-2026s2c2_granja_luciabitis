import wollok.game.*
import src.cultivos.*

object femenino {
	method prefijo() = "f"
	
	method otro() = masculino
}

object masculino {
	method prefijo() = "m"
	
	method otro() = femenino
}

object personaje {
	var property genero = femenino
	var property position = game.center()
	const propiedad = granja
	
	method image() = ((genero.prefijo() + "-player-") + self.estado()) + ".png"
	
	method estado() = if (self.estaSobreAlgo()) "abajo" else "normal"
	
	method estaSobreAlgo() = not game.colliders(self).isEmpty()
	
	method cambiarGenero() {
		genero = genero.otro()
	}
	
	method plantar(cultivo) {
		propiedad.plantar(cultivo, self.position())
	}
	
	method regar() {
		self.validarRiego()
		granja.regarCultivo(self.position())
	}
	
	method validarRiego() {
		if (!propiedad.hayCultivo(self.position())) self.error(
				"no tengo nada para regar"
			)
	}
}

object mercado {
	const property position = game.at(5, 5)
	const property image = "mercado.png"
}

object granja {
	const property cultivos = #{}
	
	method plantar(cultivo, position) {
		self.validarPlantar(cultivo, position)
		cultivo.position(position)
		cultivos.add(cultivo)
		game.addVisual(cultivo)
	}
	
	method validarPlantar(cultivo, position) {
		if (not self.puedePlantar(cultivo, position)) self.error(
				"No se puede plantar"
			)
	}
	
	method puedePlantar(cultivo, position) = (not cultivos.contains(
		cultivo
	)) and (not self.hayCultivo(position))
	
	method hayCultivo(position) = cultivos.any(
		{ cultivo => cultivo.position() == position }
	)
	
	method vaciar() {
		cultivos.clear()
	}

	method cultivoActual(_position) {
	  return cultivos.find{cultivo => cultivo.position() == _position}
	}

	method regarCultivo(position) {
	  self.cultivoActual(position).regar()
	}
}