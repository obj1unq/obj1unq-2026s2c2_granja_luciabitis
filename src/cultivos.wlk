import wollok.game.*

object bebe {
	method fase() = "bebe"
}

object adulto {
	method fase() = "adulto"
}

class Maiz {
	var property position = game.center()
	var property estado = bebe
	
	method image() = ("maiz_" + estado.fase()) + ".png"
	
	method regar() {
		estado = adulto
	}
}

class Trigo {
	var property position = game.center()
	var property etapa = 0
	
	method image() = ("trigo_" + self.etapa()) + ".png"
	
	method regar() {
		if (etapa < 3) {
			etapa += 1
		} else {
			etapa = 0
		}
	}
}

class Tomaco {
	var property position = game.center()
	
	method image() = "tomaco.png"

	method regar(){
	  self.moverPorRiego()
	}

	method moverPorRiego() {
	  if(self.position().y() = game.height - 1) {
		position = self.position().y() = 0 
	  }else {
position = position.up(1)
	  }
	}
}