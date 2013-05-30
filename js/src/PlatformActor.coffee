define ['vendor/Box2dWeb-2.1.a.3', 'bin/ActorPixi', 'bin/ActorDOM'], (Box2D, ActorPixi, ActorDOM) ->

	class PlatformActor extends ActorPixi

		constructor: () ->
			@lifeSpan = 0
			@lifeCount = 0			
			game.addEventListener("BeginContact", @beginContact)
			super

		beginContact: (contact) =>
			if contact.m_fixtureA.GetUserData() == @id || contact.m_fixtureB.GetUserData() == @id
				if contact.m_fixtureA.GetUserData() == "hero" || contact.m_fixtureB.GetUserData() == "hero"
					@die()
				else
					@el.alpha -= .1
					if @el.alpha <= 0
						@die()

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

		die: () ->
			game.removeEventListener("EndContact", @endContact)
			super

		update: () ->
			if @y > window.innerHeight
				@die()
			super

	return PlatformActor