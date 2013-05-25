define 'DOMtra', ['bin/EventDispatcher', 'vendor/Box2dWeb-2.1.a.3', 'bin/ActorManager', 'vendor/requestAnimationFrame'], (EventDispatcher, Box2D, ActorManager, requestAnimFrame) ->

	class DOMtra extends EventDispatcher

		# special vars for actors
		DRAW_SCALE = 32

		# some Box2D short-form references
		window.b2World = Box2D.Dynamics.b2World
		window.b2Vec2 = Box2D.Common.Math.b2Vec2
		window.b2DebugDraw = Box2D.Dynamics.b2DebugDraw

		constructor: (options) ->

			@options = options || {}

			# create a global for this game
			window.game = @;

			# get our console div
			@el = document.createElement("div")
			@el.setAttribute("id", "console")
			@el.style.position = "absolute"
			@el.style.left = 50
			@el.style.top = 50
			@el.style.width = 200
			@el.style.height = 200
			@el.style.opacity = .75
			@el.style.color = "white"

			# append our element to the document body
			document.body.appendChild(@el)
			
			# start a new PIXI stage
			@stage = new PIXI.Stage(0x000000)

			# start a renderer
			@renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight)

			# add it to the document
			document.body.appendChild(@renderer.view)

			addEventListener('mousedown', @spawnBlock)

			# start a box2d world
			@world = new b2World(new b2Vec2(0, 30), true)

			# start an actor manager
			@actorManager = new ActorManager(@)

			@contactListener =
				BeginContact: (idA, idB) ->
					return 1
				EndContact: () ->
					return 1
				PreSolve: () ->
					return 1
				PostSolve: (idA, idB, impulse) ->
					actorA = game.actorManager.getActorByUID(idA)
					actorB = game.actorManager.getActorByUID(idB)
					if actorA != -1 && actorB != -1
						if(actorA.dynamic)
							actorA.hit(actorB)
						if(actorB.dynamic)
							actorB.hit(actorA)

			#@addContactListener(@contactListener)

			@maxBricks = 300

			super

		# function to create a new contact listener
		addContactListener: (callbacks) ->
			listener = new Box2D.Dynamics.b2ContactListener

			if callbacks.BeginContact then listener.BeginContact = (contact) ->
				callbacks.BeginContact(contact.GetFixtureA().GetBody().GetUserData(), contact.GetFixtureB().GetBody().GetUserData())

			if callbacks.EndContact then listener.EndContact = (contact) ->
				callbacks.EndContact(contact.GetFixtureA().GetBody().GetUserData(), contact.GetFixtureB().GetBody().GetUserData())

			if callbacks.PostSolve then listener.PostSolve = (contact, impulse) ->
				callbacks.PostSolve(contact.GetFixtureA().GetBody().GetUserData(), contact.GetFixtureB().GetBody().GetUserData(), impulse.normalImpulses[0])

			@world.SetContactListener(listener)

		spawnBlock: (evt) =>
			for x in [0..10]
				@actorManager.spawnActor('PlatformActor', { width: 16, height: 16, x: evt.x, y: evt.y, rotation: true, dynamic: evt.button == 0 })

		createBody: (bodyDef, fixDef) ->
			body = @world.CreateBody(bodyDef)
			body.CreateFixture(fixDef)
			return body

		removeBody: (body) ->
			@world.DestroyBody(body)

		start: () ->
			assetsToLoader = [ "images/columbo_sheet.json"]

			loader = new PIXI.AssetLoader(assetsToLoader)

			loader.onComplete = () =>
				@init()

			loader.load()


		init: () ->
			@spawnHero()
			@actorManager.spawnActor('PlatformActor', { width: window.innerWidth * .5, height: 32, x: window.innerWidth / 4, y: window.innerHeight - 32 })
			for i in [0..5]
				@actorManager.spawnActor('PlatformActor', { density: 50, width: 256, height: 32, x: window.innerWidth * Math.random(), y: i * 100 + 200, dynamic: true, rotation: true, fixed: true })
			requestAnimFrame @update
			@dispatch("gameStarted")

		spawnHero: () ->
			@actorManager.spawnActor('ActorPixiHero', { width: 34, height: 52, x: (window.innerWidth * .5) * Math.random() + (window.innerWidth / 4), y: 200 })

		spawnBricks: () ->
			if @actorManager.actors.length < @maxBricks
				size = Math.floor(Math.random() * 32) + 8
				@actorManager.spawnActor('PlatformActor', { width: size, height: size, x: Math.random() * window.innerWidth, y: -50, rotation: true, dynamic: true })

		log: (message) ->
			@el.innerHTML += "<br />" +  message

		update: () =>
			@el.innerHTML = ""
			requestAnimFrame @update
			@spawnBricks()
			@actorManager.update()
			@world.Step(1 / 60, 10, 10);
			@renderer.render(@stage)

	return DOMtra

			