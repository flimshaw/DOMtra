define ['vendor/Box2dWeb-2.1.a.3', 'vendor/pixi.dev', 'bin/Actor'], (Box2D, PIXI, Actor) ->

	# special vars for actors
	DRAW_SCALE = 32

	class ActorPixi extends Actor

		@body = false

		preSetup: () ->
			@dynamic = true
			@rotation = true

		postSetup: () ->
			texture = PIXI.Texture.fromImage("images/brick.gif")
			@el = new PIXI.Sprite(texture)
			@el.position.x = @x
			@el.position.y = @y
			@el.anchor.x = .5
			@el.anchor.y = .5
			@el.width = @width
			@el.height = @height
			body.stage.addChild(@el)
			@elReady = true

		remove: () ->
			game.stage.removeChild(@el)

		update: () ->
			if @body.IsAwake() != undefined && @elReady == true
				@x = @el.position.x = (@body.GetPosition().x * DRAW_SCALE)
				@y = @el.position.y = (@body.GetPosition().y * DRAW_SCALE)
				@el.rotation = @body.GetAngle()

	return ActorPixi