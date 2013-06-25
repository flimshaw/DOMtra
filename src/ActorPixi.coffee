define ['vendor/Box2dWeb-2.1.a.3', 'vendor/pixi.dev', 'bin/Actor'], (Box2D, PIXI, Actor) ->

	# special vars for actors
	DRAW_SCALE = 32

	# map all our wacky Box2D methods to some more accessible places
	b2Vec2 = Box2D.Common.Math.b2Vec2
	b2AABB = Box2D.Collision.b2AABB
	b2BodyDef = Box2D.Dynamics.b2BodyDef
	b2Body = Box2D.Dynamics.b2Body
	b2FixtureDef = Box2D.Dynamics.b2FixtureDef
	b2Fixture = Box2D.Dynamics.b2Fixture
	b2World = Box2D.Dynamics.b2World
	b2MassData = Box2D.Collision.Shapes.b2MassData
	b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
	b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
	b2DebugDraw = Box2D.Dynamics.b2DebugDraw
	b2MouseJointDef =  Box2D.Dynamics.Joints.b2MouseJointDef

	class ActorPixi extends Actor

		@body = false

		preSetup: () ->
			defaultAnimations =
				default:
					frames: ["question_box_0.png", "question_box_1.png"]
					speed: 15
			@animations = if @options.animations == undefined then defaultAnimations else @options.animations

		postSetup: () ->
			texture = PIXI.Texture.fromFrame(@currentAnimation.frames[0])
			@el = new PIXI.Sprite(texture)
			@el.position.x = @x
			@el.position.y = @y
			@el.anchor.x = .5
			@el.anchor.y = .5
			@el.scale.x = 1
			@el.scale.y = 1
			game.stage.addChild(@el)
			@el.width = @width
			@el.height = @height
			@elReady = true

		setup: () =>
			@animateSpeed = 15
			@frameCount = 0
			@animationCounter = 0
			@setAnimation("default")

			# create a fixture with some default settings
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
			bodyDef.userData = @id
			bodyDef.fixedRotation = !@rotation # set our rotation, which is actually bizarro for box2d
			bodyDef.allowSleep = @allowSleep

			# instantiate our body element, and add it to the world
			@body = game.createBody(bodyDef, fixDef)

		remove: () ->
			super()
			game.stage.removeChild(@el)

		update: () ->
			if @body.IsAwake() && @elReady == true
				@x = (@body.GetPosition().x * DRAW_SCALE)
				@y = (@body.GetPosition().y * DRAW_SCALE)
			@el.rotation = @body.GetAngle()
			@el.position.x = @x + game.offset.x
			@el.position.y = @y + game.offset.y
			@animate()
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