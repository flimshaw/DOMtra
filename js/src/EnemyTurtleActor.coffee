define ['bin/Actor'], (Actor) ->

	class EnemyTurtleActor extends Actor

		constructor: (id, options) ->
			options.dynamic = true
			options.rotation = true
			options.width = 32
			options.height = 48
			options.className = "enemyTurtleActor"
			super(id, options)

		update: () ->
			super
			if @y > window.innerHeight
				@die()

		setup: () ->
			super
			x = Math.floor(Math.random() * 8) * @width - 2
			y = Math.floor(Math.random() * 3) * @height
			@el.style.backgroundPosition = "-#{x}px -#{y}px"

	return EnemyTurtleActor