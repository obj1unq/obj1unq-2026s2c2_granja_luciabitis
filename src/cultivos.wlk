import wollok.game.*
import granja.*

object bebe {
	method fase() = "bebe"
	method listoParaCosecha() = false
}

object adulto {
	method fase() = "adulto"
	method listoParaCosecha() = true
}

class Maiz {
	var property position = game.center()
	var property estado = bebe
	
	method image() = ("maiz_" + estado.fase()) + ".png"
	
	method regar() {
		estado = adulto
	}

	method cosechar() {
	  game.removeVisual(self)
	}

	method listoParaCosecha() {
	  return estado.listoParaCosecha()
	}

	method precio() {
	  return 150
	}
}

class Trigo {
	var property position = game.center()
	var property etapa = 0
	
	method image() = ("trigo_" + etapa) + ".png"
	
	method regar() {
		if (etapa < 3) {
			etapa += 1
		} else {
			etapa = 0
		}
	}

	method cosechar() {
	  game.removeVisual(self)
	}

	method listoParaCosecha() {
	  return etapa >= 2
	}

	method precio() {
	  return (etapa - 1) * 100
	}
}

class Tomaco {
	var property position = game.center()
	
	method image() = "tomaco.png"
	
	method regar() {
		self.moverPorRiego()
	}
	
	method moverPorRiego() {
		if (granja.lugarLibre(self.proximaPosicion())) {
        position = self.proximaPosicion()
        }
	}
	
	method proximaPosicion() = if (self.position().y() == (game.height() - 1))
	                           	game.at(self.position().x(), 0)
	                           else position.up(1)

	method cosechar() {
	  game.removeVisual(self)
	}

	method listoParaCosecha() {
	  return true
	}
	method precio() {
	  return 80
	}
}