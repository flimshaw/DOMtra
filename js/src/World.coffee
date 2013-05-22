define ['vendor/Box2dWeb-2.1.a.3', 'vendor/pixi.dev'], (Box2D, PIXI) ->

	b2World = Box2D.Dynamics.b2World
	b2Vec2 = Box2D.Common.Math.b2Vec2
	b2DebugDraw = Box2D.Dynamics.b2DebugDraw

	class World
		# You can add statements inside the class definition
		# which helps establish private scope (due to closures)
		# instance is defined as null to force correct scope
		instance = null
		# Create a private class that we can initialize however
		# defined inside this scope to force the use of the
		# singleton class.
		class PrivateClass
			@world = null
			@stage = null

			@b2World = Box2D.Dynamics.b2World
			@b2Vec2 = Box2D.Common.Math.b2Vec2
			@b2DebugDraw = Box2D.Dynamics.b2DebugDraw

			constructor: () ->
				# create ourselves a world with some standard-style gravity
				@world = new b2World(new b2Vec2(0, 10), true)
				@stage = new PIXI.Stage(0x000000)
				@renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight)
				document.body.appendChild(@renderer.view)

			createBody: (bodyDef, fixDef) ->
				body = @world.CreateBody(bodyDef)
				body.CreateFixture(fixDef)
				return body

			removeBody: (body) ->
				@world.DestroyBody(body)

			update: () ->
				@world.Step(1 / 60, 10, 10);
				@renderer.render(@stage)
				@world.ClearForces();

		# This is a static method used to either retrieve the
		# instance or create a new one.
		@get: () ->
			instance ?= new PrivateClass()