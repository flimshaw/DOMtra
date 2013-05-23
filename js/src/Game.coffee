define ['bin/EventDispatcher', 'vendor/Box2dWeb-2.1.a.3', 'bin/ActorManager', 'vendor/requestAnimationFrame'], (EventDispatcher, Box2D, ActorManager, requestAnimFrame) ->

	class PlatformGame extends EventDispatcher

		# special vars for actors
		DRAW_SCALE = 32

		# some Box2D short-form references
		b2World = Box2D.Dynamics.b2World
		b2Vec2 = Box2D.Common.Math.b2Vec2
		b2DebugDraw = Box2D.Dynamics.b2DebugDraw

		constructor: () ->

			# create a global for this game
			window.game = @;
			
			# start a new PIXI stage
			@stage = new PIXI.Stage(0x000000)

			# start a renderer
			@renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight)

			# add it to the document
			document.body.appendChild(@renderer.view)

			# start a box2d world
			@world = new b2World(new b2Vec2(0, 10), true)

			# start an actor manager
			@actorManager = new ActorManager(@)

			@maxColumbos = 1000

			super

		createBody: (bodyDef, fixDef) ->
			body = @world.CreateBody(bodyDef)
			body.CreateFixture(fixDef)
			return body

		removeBody: (body) ->
			@world.DestroyBody(body)

		start: () ->
			@actorManager.spawnActor('PlatformActor', { width: window.innerWidth, height: 32, x: 0, y: window.innerHeight - 32 })
			@spawnHero()
			requestAnimFrame @update
			@dispatch("gameStarted")

		spawnHero: () ->
			@actorManager.spawnActor('ActorPixiHero', { x: (window.innerWidth * .9) * Math.random(), y: 200 })

		spawnColumbos: () ->
			if @actorManager.actors.length < @maxColumbos
				@actorManager.spawnActor('ActorPixiColumbo', { width: 34, height: 52, x: window.innerWidth * Math.random(), y: -80 })

		update: () =>
			requestAnimFrame @update
			#@spawnColumbos()
			@actorManager.update()
			@world.Step(1 / 60, 10, 10);
			@renderer.render(@stage)
			