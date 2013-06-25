define ['vendor/Box2dWeb-2.1.a.3', 'bin/ActorPixi', 'bin/ActorDOM'], (Box2D, ActorPixi, ActorDOM) ->

	class PlatformActor extends ActorSwitch

		constructor: () ->
			@lifeSpan = 0
			@lifeCount = 0
			super

		preSetup: () ->
			@className = 'platform'
			@restitution = 0
			super

		postSetup: () ->
			if @options.fixed == true
				jointDef = new Box2D.Dynamics.Joints.b2RevoluteJointDef()
				jointDef.Initialize(game.world.GetGroundBody(), @body, @body.GetWorldCenter())
				game.world.CreateJoint(jointDef)
			super

		update: () ->
			if @y > window.innerHeight
				@die()
			super

	return PlatformActor