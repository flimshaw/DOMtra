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
		@numFootContacts = 0

		jump: () =>
			if @canJump()
				@jumping = true
				impulse = @body.GetMass() * @jumpPower
				@body.ApplyImpulse(new b2Vec2(0, -impulse), @body.GetWorldCenter())

		canJump: () ->
			if !@body.GetContactList()
				return false

			contact = @body.GetContactList().contact
			if !@isFootContact(contact)
				while contact = contact.m_next
					if @isFootContact(contact)
						if contact.IsTouching()
							return true
			return false

		isFootContact: (contact) ->
			if contact.m_fixtureA.GetUserData() == "heroFootSensor" || contact.m_fixtureB.GetUserData() == "heroFootSensor"
				return true
			return false

		keyboardDownListener: (evt) =>
			switch evt.keyCode
				when 32 then @jump()
				when 37 then @heroDirection = "left"
				when 39 then @heroDirection = "right"
				else console.log(evt.keyCode)

		keyboardUpListener: (evt) =>
           if evt.keyCode == 37 || evt.keyCode == 39 then @heroDirection = false

		setup: () ->
			@jumpCount = 0
			@jumping = false
			@animateSpeed = 15
			@frameCount = 0
			@animationCounter = 0

			@animations = 
				walk:
					frames: ["columbo_walk_0.png", "columbo_walk_1.png"],
					speed: 15
				fumble:
					frames: ["columbo_rifle_cigar_0.png", "columbo_rifle_cigar_1.png", "columbo_rifle_cigar_2.png", "columbo_rifle_cigar_3.png"]
					speed: 15
				jump:
					frames: ["columbo_jump.png"]
					speed: 15

			@setAnimation("fumble")

			@id = "hero"
			# create a platform with some default settings
			fixDef = new b2FixtureDef
			fixDef.density = @density
			fixDef.friction = @friction
			fixDef.restitution = @restitution
			
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
			footDef.shape.SetAsOrientedBox((@width) / DRAW_SCALE, .3, new b2Vec2(0, (@height / 2) / DRAW_SCALE), 0)
			footSensorFixture = @body.CreateFixture(footDef)
			footSensorFixture.SetUserData("heroFootSensor")

			@hitCount = 0

			@contactListener =
				BeginContact: (contact) =>
					if contact.m_fixtureA.GetUserData() == "heroFootSensor" || contact.m_fixtureB.GetUserData() == "heroFootSensor"
						@jumping = false
				EndContact: (contact) =>
					if contact.m_fixtureA.GetUserData() == "heroFootSensor" || contact.m_fixtureB.GetUserData() == "heroFootSensor"
						@jumpCount--
				PreSolve: () ->
					return 1
				PostSolve: (contact, impulse) ->
					return 1

			@addContactListener(@contactListener)

		hit: (actor) ->
			#console.log(actor)

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
			@allowSleep = false

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
			game.stage.addChild(@el)
			@elReady = true

		animate: () ->
			if @jumping == true
				if @currentAnimationName != "jump"
					@setAnimation("jump")
			else if @heroDirection != false
				if @currentAnimationName != "walk"
					@setAnimation("walk")
			else
				if @currentAnimationName != "fumble"
					@setAnimation("fumble")

			if @frameCount % @animateSpeed == 0
				@animationCounter++
				if @animationCounter > @currentAnimation.frames.length - 1
					@animationCounter = 0
				@el.setTexture(PIXI.Texture.fromFrame(@currentAnimation.frames[@animationCounter]))
			if @frameCount > 100
				@frameCount = 0
			@frameCount++

		update: () ->
			lv = @body.GetLinearVelocity();
			
			if @heroDirection == "right" 
				@body.SetLinearVelocity(new b2Vec2(@walkPower, lv.y))
			else if @heroDirection == "left"
				@body.SetLinearVelocity(new b2Vec2(-@walkPower, lv.y))
			else
				if lv.x != 0
					if Math.abs(lv.x) < .1
						lv.x = 0
					@body.SetLinearVelocity(new b2Vec2(lv.x * .95, lv.y))

			@animate()

			super


	return ActorPixiHero