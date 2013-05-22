define ['vendor/Box2dWeb-2.1.a.3', 'vendor/pixi.dev', 'bin/World', 'bin/ActorPixi'], (Box2D, PIXI, World, ActorPixi) ->

	# special vars for actors
	DRAW_SCALE = 32

	b2World = Box2D.Dynamics.b2World
	b2Vec2 = Box2D.Common.Math.b2Vec2
	b2DebugDraw = Box2D.Dynamics.b2DebugDraw

	class ActorPixiHero extends ActorPixi

		@body = false

		@jump = false

		jump: () =>
			console.log("applyingForce")
			vec = new b2Vec2( 0, -500)
			@body.ApplyImpulse(vec, @body.GetWorldCenter())

		keyboardDownListener: (evt) =>
			switch evt.keyCode
				when 38 then @jump()
				when 37 then @heroDirection = "left"
				when 39 then @heroDirection = "right"
				else console.log(evt.keyCode)

		keyboardUpListener: (evt) =>
           if evt.keyCode == 37 || evt.keyCode == 39 then @heroDirection = false

		preSetup: () ->
			@dynamic = true
			@rotation = false
			@width = 128
			@height = 128
			@restitution = 0
			@density = 1.5

			# custom vars
			@jumpVector = 270
			@jumpPower = 10
			@walkPower = 10
			@heroDirection = false

			addEventListener('keydown', @keyboardDownListener, true);

		postSetup: () ->
			texture = PIXI.Texture.fromImage("images/test_sprite.jpg")
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
			lv = @body.GetLinearVelocity();

			if @heroDirection == "right" 
				@body.SetLinearVelocity(new b2Vec2(@walkPower, lv.y))
			else if @heroDirection == "left"
				@body.SetLinearVelocity(new b2Vec2(-@walkPower, lv.y))

			super


	return ActorPixiHero