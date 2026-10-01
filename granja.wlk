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
	var property bolsoActual = bolso
	
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
		self.validarRiego(self.position())
		propiedad.regarCultivo(self.position())
	}
	
	method cosechar() {
		self.validarCosecha(self.position())
		const cultivoCosechado = propiedad.cultivoActual(self.position())
		propiedad.cosecharCultivo(self.position())
		bolsoActual.agregarCosecha(cultivoCosechado)
	}
	
	method vender() {
		bolsoActual.agregarOro(mercado.oroPorCadaCosecha(bolso.cosecha()))
        bolsoActual.vaciarCosecha()
	}
	
	method text() = ("tengo" + bolso.oroTotal()) + "de oro"
	
	method infoSobreLaVenta() {
		game.say(
			self,
			((("Tengo " + bolsoActual.cosechaTotal()) + " plantas para vender por ") + bolsoActual.oroPorConseguir()) + " monedas "
		)
	}
	method validarRiego(_position) {
		if (!propiedad.hayCultivo(_position)) self.error("no tengo nada para regar")
	}
method validarCosecha(_position) {
		if ((! propiedad.hayCultivo(
				_position
			)) or (! propiedad.elCultivoEstaListoParaCosechar(_position))) self.error(
				"no se puede cosechar"
			)
	}
}

object bolso {
	const cosecha = []
	var oroTotal = 0
	
	method cosecha() = cosecha
	
	method agregarCosecha(cultivo) {
		cosecha.add(cultivo)
	}
	
	method removerCosecha(cultivo) {
		cosecha.remove(cultivo)
	}
	
	method vaciarCosecha() {
		cosecha.clear()
	}
	
	method agregarOro(cantidad) { oroTotal = oroTotal + cantidad }
	
	
	method oroTotal() = oroTotal
	
	
	method cosechaTotal() = cosecha.size()
	
	method oroPorConseguir() = mercado.oroPorCadaCosecha(self.cosecha())
}

object mercado {
	const property position = game.at(5, 5)
	const property image = "mercado.png"
	
	method oroPorCadaCosecha(cosechas) = if (cosechas.isEmpty()) 0 else cosechas.sum({ cosecha => cosecha.precio() })
	
	
	method interactuar(_personaje) {
		_personaje.vender()
	}
}

object granja {
	const property cultivos = []
	
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
	
	method puedePlantar(cultivo, position) = ! cultivos.contains(cultivo) && self.lugarLibre(position)
	
	method hayCultivo(position) = cultivos.any(
		{ cultivo => cultivo.position() == position }
	)
	
	method vaciar() {
		cultivos.clear()
	}
	
	method cultivoActual(_position) = cultivos.find(
		{ cultivo => cultivo.position() == _position }
	)
	
	method regarCultivo(position) {
		
		self.cultivoActual(position).regar()
	}
	
	method cosecharCultivo(position) {
		
		self.cultivoActual(position).cosechar()
		cultivos.remove(self.cultivoActual(position))
	}
	
	method elCultivoEstaListoParaCosechar(position) = self.cultivoActual(
		position
	).listoParaCosecha()
	
	method lugarLibre(position) = not self.hayCultivo(position) and position != mercado.position()
	
}