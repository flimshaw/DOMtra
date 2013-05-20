# DOMtra: DOM element platform engine, utilizing the Box2D physics library
define ['vendor/Box2dWeb-2.1.a.3', 'bin/World', 'bin/ActorManager', 'vendor/requestAnimationFrame'], (Box2D, World, ActorManager, requestAnimFrame) ->

	class DOMtra

		# grab an instance of our singleton World class
		@world = -1

		# also grab an instance of our ActorFactory class
		@actorManager = -1

		# flag to prevent people updating us before we're ready
		@ready = false

		# flag to tell if we're running or not
		@running = false

		# flag to tell if we have started our frame listener yet
		@started = false

		constructor: () ->
			console.log("DOMtra started")

			window.DOMtra = @

			# get an instance of our world
			@world = World.get()

			# create an Actor Manager
			@actorManager = new ActorManager()

			@contactListener =
				BeginContact: (idA, idB) ->
					return 1
				EndContact: () ->
					return 1
				PreSolve: () ->
					return 1
				PostSolve: (idA, idB, impulse) ->
					actorA = window.DOMtra.getActor(idA)
					actorB = window.DOMtra.getActor(idB)
					if actorA != -1 && actorB != -1
						if(actorA.dynamic)
							actorA.hit(actorB)
						if(actorB.dynamic)
							actorB.hit(actorA)

			@addContactListener(@contactListener)

			@ready = true

		# function to create a new contact listener
		addContactListener: (callbacks) ->
			listener = new Box2D.Dynamics.b2ContactListener

			if callbacks.BeginContact then listener.BeginContact = (contact) ->
				callbacks.BeginContact(contact.GetFixtureA().GetBody().GetUserData(), contact.GetFixtureB().GetBody().GetUserData())

			if callbacks.EndContact then listener.EndContact = (contact) ->
				callbacks.EndContact(contact.GetFixtureA().GetBody().GetUserData(), contact.GetFixtureB().GetBody().GetUserData())

			if callbacks.PostSolve then listener.PostSolve = (contact, impulse) ->
				callbacks.PostSolve(contact.GetFixtureA().GetBody().GetUserData(), contact.GetFixtureB().GetBody().GetUserData(), impulse.normalImpulses[0])

			@world.world.SetContactListener(listener)

		# batch-spawn a bunch of actors based on a JSON file
		buildLevel: (levelJSON) ->
			return 1	

		# create an actor from a string and a json packet
		createActor: (actorType, options) ->
			@actorManager.spawnActor(actorType, options)

		# get an actor by their id
		getActor: (id) ->
			@actorManager.getActorByUID(id)

		# remove this actor from both the dom and the world
		deleteActor: (actor) ->
			@actorManager.deleteActor(actor)

		start: () ->
			if !@started
				@loop()
				@started = true
			@running = true

		stop: () ->
			@running = false

		customUpdate: () ->
			return true

		loop: () =>
			requestAnimFrame @loop
			@update()

		update: () ->
			if @ready == true && @running == true
				@actorManager.update()
				@world.update()
				@customUpdate()


	return DOMtra