define ['vendor/Box2dWeb-2.1.a.3', 'vendor/pixi.dev', 'bin/Actor'], (Box2D, PIXI, Actor) ->

	# special vars for actors
	DRAW_SCALE = 32

	class ActorPixi extends Actor

		@body = false

		postSetup: () ->
			if @options.sprite != undefined
				texture = PIXI.Texture.fromFrame(@options.sprite)
			else
				texture = PIXI.Texture.fromFrame("question-box.png")
			@el = new PIXI.Sprite(texture)
			@el.position.x = @x
			@el.position.y = @y
			@el.anchor.x = .5
			@el.anchor.y = .5
			@el.width = @width
			@el.height = @height
			game.stage.addChild(@el)
			@elReady = true

		setup: () =>
			@footContacts = 0
			@jumping = false
			@animateSpeed = 15
			@frameCount = 0
			@animationCounter = 0
			@pressedKeys = []

			@walkSpeed = 10

			@animations = 
				walk:
					frames: ["hero_walk2.png", "hero_walk3.png", "hero_walk2.png", "hero_walk1.png" ],
					speed: 12
				stand:
					frames: ["hero_stand.png"]
					speed: 50
				jump:
					frames: ["hero_jump.png"]
					speed: 15

			@setAnimation("jump")

			game.addEventListener("BeginContact", @beginContact)
			game.addEventListener("EndContact", @endContact)

			@id = "hero"
			# create a platform with some default settings
			fixDef = new b2FixtureDef
			fixDef.density = @density
			fixDef.friction = @friction
			fixDef.restitution = @restitution
			fixDef.userData = @id
			fixDef.shape = new b2PolygonShape
			fixDef.shape.SetAsBox((@width / 2) / DRAW_SCALE, (@height / 2) / DRAW_SCALE)

			# create a new body definition
			bodyDef = new b2BodyDef
			if @dynamic
				bodyDef.type = b2Body.b2_dynamicBody
			else
				bodyDef.type = b2Body.b2_staticBody

			# positions the center of the object (not upper left!)
			wX = (@x + (@width / 2)) / DRAW_SCALE
			wY = (@y + (@height / 2)) / DRAW_SCALE
			bodyDef.position.Set(wX, wY)
			bodyDef.userData = "hero"
			bodyDef.fixedRotation = !@rotation
			bodyDef.allowSleep = @allowSleep

			# instantiate our body element, and add it to the world
			@body = game.createBody(bodyDef, fixDef)

			footDef = new b2FixtureDef
			footDef.isSensor = true
			footDef.shape = new b2PolygonShape
			footDef.shape.SetAsOrientedBox((@width / 4) / DRAW_SCALE, .3, new b2Vec2(0, (@height / 2) / DRAW_SCALE), 0)
			footSensorFixture = @body.CreateFixture(footDef)
			footSensorFixture.SetUserData("heroFootSensor")

			@hitCount = 0

		remove: () ->
			super()
			game.stage.removeChild(@el)

		update: () ->
			if @body.IsAwake() && @elReady == true
				@x = @el.position.x = (@body.GetPosition().x * DRAW_SCALE)
				@y = @el.position.y = (@body.GetPosition().y * DRAW_SCALE)
				if @rotation
					@el.rotation = @body.GetAngle()
			super()

		setAnimation: (animation) ->
			@currentAnimation = @animations[animation]
			@currentAnimationName = animation
			@animationCounter = 0
			@frameCount = 0

		animate: () ->
			# if we're set to reverseSprite, flip the sprite depending on x velocity
			if @options.reverseSprite == true
				if @currentVel.x < 0
					@el.scale.x = -1
				else if @currentVel.x > 0
					@el.scale.x = 1

			if @frameCount % @currentAnimation.speed == 0
				@animationCounter++
				if @animationCounter > @currentAnimation.frames.length - 1
					@animationCounter = 0
				@el.setTexture(PIXI.Texture.fromFrame(@currentAnimation.frames[@animationCounter]))
			if @frameCount > 100
				@frameCount = 0
			@frameCount++

	return ActorPixi