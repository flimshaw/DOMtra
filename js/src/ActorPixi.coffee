define ['vendor/Box2dWeb-2.1.a.3', 'vendor/pixi.dev', 'bin/Actor'], (Box2D, PIXI, Actor) ->

	# special vars for actors
	DRAW_SCALE = 32

	class ActorPixi extends Actor

		@body = false

		postSetup: () ->
			texture = PIXI.Texture.fromFrame("mario-question-box.png")
			@el = new PIXI.Sprite(texture)
			@el.position.x = @x
			@el.position.y = @y
			@el.anchor.x = .5
			@el.anchor.y = .5
			@el.width = @width
			@el.height = @height
			game.stage.addChild(@el)
			@elReady = true

		remove: () ->
			super()
			game.stage.removeChild(@el)

		update: () ->
			if @body.IsAwake() && @elReady == true
				@x = @el.position.x = (@body.GetPosition().x * DRAW_SCALE)
				@y = @el.position.y = (@body.GetPosition().y * DRAW_SCALE)
				if @rotation
					@el.rotation = @body.GetAngle()
				@el.alpha = 1
			else
				@el.alpha = 0.5

	return ActorPixi