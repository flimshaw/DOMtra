define ['vendor/Box2dWeb-2.1.a.3', 'vendor/pixi.dev', 'bin/World', 'bin/ActorPixi'], (Box2D, PIXI, World, ActorPixi) ->

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

	class ActorPixiHero extends ActorPixi

		@body = false

		jump: () =>
			if @canJump()
				@jumping = true
				impulse = @body.GetMass() * @jumpPower
				@body.ApplyImpulse(new b2Vec2(0, -impulse), @body.GetWorldCenter())

		canJump: () ->
			if @footContacts > 0
				true
			else
				false

		isFootContact: (contact) ->
			if contact.m_fixtureA.GetUserData() == "heroFootSensor" || contact.m_fixtureB.GetUserData() == "heroFootSensor"
				return true
			return false

		keyboardDownListener: (evt) =>
			switch evt.keyCode
				when 32 
					@jump()
					evt.preventDefault()
				when 37 then @pressKey("left")
				when 39 then @pressKey("right")
				else console.log(evt.keyCode)

		keyboardUpListener: (evt) =>
			if evt.keyCode == 37
				@resetKey("left")
			if evt.keyCode == 39
				@resetKey("right")

		pressKey: (key) ->
			@pressedKeys[key] = true

		keyPressed: (key) ->
			if @pressedKeys[key] == true
				return true
			else
				return false

		resetKey: (key) ->
			@pressedKeys[key] = false

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

		
		beginContact: (contact) =>
			if contact.m_fixtureA.GetUserData() == "heroFootSensor" || contact.m_fixtureB.GetUserData() == "heroFootSensor"
				@footContacts++
				
		endContact: (contact) =>
			if contact.m_fixtureA.GetUserData() == "heroFootSensor" || contact.m_fixtureB.GetUserData() == "heroFootSensor"
				@footContacts--

		setAnimation: (animation) ->
			@currentAnimation = @animations[animation]
			@currentAnimationName = animation
			@animationCounter = 0
			@frameCount = 0

		preSetup: () ->
			@dynamic = true
			@rotation = false
			@restitution = 0
			@friction = 0
			@density = 1

			# custom vars
			@jumpVector = 270
			@jumpPower = 15
			@walkPower = 10
			@heroDirection = false

			# add keyboard listeners
			addEventListener('keydown', @keyboardDownListener, true);
			addEventListener('keyup', @keyboardUpListener, true);

		postSetup: () ->
			texture = PIXI.Texture.fromFrame(@currentAnimation.frames[0])
			@el = new PIXI.Sprite(texture)
			@el.position.x = @x
			@el.position.y = @y
			@el.anchor.x = .5
			@el.anchor.y = .5
			@el.width = @width
			@el.height = @height
			@el.scale.x = 1
			@el.scale.y = 1
			game.stage.addChild(@el)
			@elReady = true

		animate: () ->
			if @footContacts <= 0
				if @currentAnimationName != "jump"
					@setAnimation("jump")
			else if Math.abs(@currentVel.x) > 0
				if @currentAnimationName != "walk"
					@setAnimation("walk")
			else
				if @currentAnimationName != "stand"
					@setAnimation("stand")

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

		update: () ->

			vel = @body.GetLinearVelocity()
			@currentVel = vel
			force = 0
			
			if @footContacts > 0 && @jumping == true && @currentVel.y < 0
				@jumping = false

			if @keyPressed("right")
				desiredVel = @walkSpeed
			else if @keyPressed("left")
				desiredVel = -@walkSpeed
			else
				desiredVel = 0

			velChange = desiredVel - vel.x

			force = (@body.GetMass() * velChange)

			@body.ApplyImpulse( new b2Vec2(force, 0), @body.GetWorldCenter() )

			@animate()

			super


	return ActorPixiHero