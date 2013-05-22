define ['vendor/Box2dWeb-2.1.a.3', 'vendor/pixi.dev', 'bin/World', 'bin/ActorPixi'], (Box2D, PIXI, World, ActorPixi) ->

	# special vars for actors
	DRAW_SCALE = 32

	class ActorPixiColumbo extends ActorPixi

		@body = false

		preSetup: () ->
			@dynamic = true
			@rotation = true
			@restitution = .8

		postSetup: () ->
			texture = PIXI.Texture.fromImage("images/columbo2.png")
			@el = new PIXI.Sprite(texture)
			@el.position.x = @x
			@el.position.y = @y
			@el.anchor.x = .5
			@el.anchor.y = .5
			@el.width = @width
			@el.height = @height
			@world.stage.addChild(@el)
			@elReady = true

		update: () ->
			super
			if @y > window.innerHeight
					@die()


	return ActorPixiColumbo