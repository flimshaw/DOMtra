define ['bin/ActorManager'], (ActorManager) ->

	class Level

		constructor: (jsonFile) ->

			@ready = false

			$.getJSON(jsonFile, @setup)

		setup: (data) =>

			# set gravity options
			game.setGravity(data.world.gravity.x, data.world.gravity.y)

			@actorsListing = data.actors

			assetsToLoader = [ data.spriteSheet ]

			loader = new PIXI.AssetLoader(assetsToLoader)

			loader.onComplete = () =>
				@initializeActors()

			loader.load()

		initializeActors: () ->

			# start an actor manager
			@actorManager = new ActorManager(@)

			for actor in @actorsListing
				@actorManager.spawnActor(actor.type, actor.options)

			for i in [0..50]
				@actorManager.spawnActor('PlatformActor', { x: window.innerWidth * Math.random(), y: window.innerHeight * Math.random(), dynamic: true, rotation: true, fixed: true })

			@ready = true

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

		update: () ->
			size = Math.random() * 16 + 8
			@actorManager.spawnActor('PlatformActor', { x: window.innerWidth * Math.random(), y: -100, width: size, height: size, dynamic: true, rotation: true  })
			@actorManager.update()