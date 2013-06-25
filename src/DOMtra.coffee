define 'DOMtra', ['bin/EventDispatcher', 'vendor/Box2dWeb-2.1.a.3', 'bin/ActorManager', 'vendor/requestAnimationFrame', 'bin/Level', 'bin/ActorPixi'], (EventDispatcher, Box2D, ActorManager, requestAnimFrame, Level, ActorPixi) ->

	class DOMtra extends EventDispatcher

		# special vars for actors
		DRAW_SCALE = 32
		@DRAW_SCALE = DRAW_SCALE


		# expose some of our prototypes for subclasses benefit
		@EventDispatcher = EventDispatcher
		@ActorManager = ActorManager
		@ActorPixi = ActorPixi
		@Level = Level
		@Box2D = Box2D

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
		b2EdgeShape = Box2D.Collision.Shapes.b2EdgeShape
		b2DebugDraw = Box2D.Dynamics.b2DebugDraw
		b2MouseJointDef =  Box2D.Dynamics.Joints.b2MouseJointDef

		# attach Box2D definitions to us for children classes to access
		@b2Vec2 = b2Vec2
		@b2AABB = b2AABB
		@b2BodyDef = b2BodyDef
		@b2Body = b2Body
		@b2FixtureDef = b2FixtureDef
		@b2Fixture = b2Fixture
		@b2World = b2World
		@b2MassData = b2MassData
		@b2PolygonShape = b2PolygonShape
		@b2CircleShape = b2CircleShape
		@b2EdgeShape = b2EdgeShape
		@b2DebugDraw = b2DebugDraw
		@b2MouseJointDef = b2MouseJointDef

		constructor: (options) ->

			@options = options || {}

			# array to hold references to all the actors that want to hear about contact events
			@bodyQueue = []

			# create a global for this game
			window.game = @;

			# append our element to the document body
			#document.body.appendChild(@el)
			
			# start a new PIXI stage
			@stage = new PIXI.Stage()
			@currentLevel = false
			@offset =
				x: 0
				y: 0

			# start a renderer
			@renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight, null, true)

			# add it to the 
			@renderer.view.style.position = "absolute"
			@renderer.view.style.top = 0
			@renderer.view.style.left = 0
			@renderer.view.style.zIndex = 0
			document.body.appendChild(@renderer.view)

			# start a box2d world
			@world = new b2World(new b2Vec2(0, 30), true)
			@startContactListener()
			super

		queueCreateBody: (bodyDef, fixDef) =>
			@bodyQueue.push({ bodyDef: bodyDef, fixDef: fixDef });

		loadLevel: (level) ->
			@currentLevel = level

		createBody: (newBodyDef, newFixDef) =>
			body = @world.CreateBody(newBodyDef)
			if body == null
				@bodyQueue.push({ bodyDef: bodyDef, fixDef: fixDef })
			else
				body.CreateFixture(newFixDef)
				return body

		# function to create a new contact listener
		startContactListener: () ->
			listener = new Box2D.Dynamics.b2ContactListener

			listener.BeginContact = (contact) ->
				game.dispatch("BeginContact", contact)

			listener.EndContact = (contact) ->
				game.dispatch("EndContact", contact)

			listener.PostSolve = (contact, impulse) ->
				game.dispatch("PostSolve", { contact: contact, impulse: impulse })

			listener.PreSolve = (contact) ->
				game.dispatch("PreSolve", contact)

			@world.SetContactListener(listener)

		removeBody: (body) ->
			@world.DestroyBody(body)

		setGravity: (x, y) ->
			@world.SetGravity(new b2Vec2(x, y))

		start: () ->
			requestAnimFrame @update
			@dispatch("gameStarted")

		update: () =>
			requestAnimFrame @update
			if @bodyQueue.length > 0
				newBody = @bodyQueue.pop()
				@createBody(newBody.bodyDef, newBody.fixDef)
				# callback to actor and assign body reference
			if @currentLevel
				@currentLevel.update()
			@world.Step(1 / 60, 8, 3)
			@renderer.render(@stage)

	return DOMtra

			