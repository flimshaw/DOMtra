define ['vendor/Box2dWeb-2.1.a.3', 'bin/ActorDOM'], (Box2D, ActorDOM) ->

	class PlatformActor extends ActorDOM

		preSetup: () ->
			@className = 'platform'
			@rotation = true
			@dynamic = true
			super

		postSetup: () ->
			jointDef = new Box2D.Dynamics.Joints.b2RevoluteJointDef()
			jointDef.Initialize(@world.world.GetGroundBody(), @body, @body.GetWorldCenter())
			@world.world.CreateJoint(jointDef)
			@el.innerHTML = "I AM A DIV"
			super

		update: () ->
			@el.innerHTML = @hitCount
			super

	return PlatformActor