define ['vendor/Box2dWeb-2.1.a.3', 'bin/Actor'], (Box2D, Actor) ->

	class PlatformActor extends Actor

		constructor: (id, options) ->
			options.dynamic = true
			options.rotation = true
			options.width = 256
			options.height = 32
			
			options.density = 3.8
			options.friction = .2
			options.restitution = .4

			options.className = "platform"
			super(id, options)

		setup: () =>
			super
			jointDef = new Box2D.Dynamics.Joints.b2RevoluteJointDef()
			jointDef.Initialize(@world.world.GetGroundBody(), @body, @body.GetWorldCenter())
			@world.world.CreateJoint(jointDef)

		update: () =>
			super

	return PlatformActor