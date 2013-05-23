define [
	'vendor/underscore',
	'bin/EventDispatcher',
	'bin/World',
	'bin/Actor',
	'bin/PlatformActor',
	'bin/QuestionMarkActor',
	'bin/EnemyTurtleActor',
	'bin/ActorDOM',
	'bin/ActorPixi'
	'bin/ActorPixiHero',
	'bin/ActorPixiColumbo'
	], (_, EventDispatcher, World, Actor, PlatformActor, QuestionMarkActor, EnemyTurtleActor, ActorDOM, ActorPixi, ActorPixiHero, ActorPixiColumbo) ->

	class Box2DActorManager extends EventDispatcher

		constructor: () ->
			super
			# object to hold all of our actor objects
			@type = @type || "ActorManager"
			@actors = []
			@world = World.get()

		# factory method, returns an Actor object based on criteria
		actorFactory: (actorType, options) ->
			switch(actorType)
				when "Actor" then new Actor(@generateUID(), options)
				when "PlatformActor" then new PlatformActor(@generateUID(), options)
				when "QuestionMarkActor" then new QuestionMarkActor(@generateUID(), options)
				when "EnemyTurtleActor" then new EnemyTurtleActor(@generateUID(), options)
				when "ActorDOM" then new ActorDOM(@generateUID(), options)
				when "ActorPixi" then new ActorPixi(@generateUID(), options)
				when "ActorPixiHero" then new ActorPixiHero(@generateUID(), options)
				when "ActorPixiColumbo" then new ActorPixiColumbo(@generateUID(), options)
				else new Actor(@generateUID(), options)

		# generate a guid for new actors
		generateUID: () ->
			guid = "d" + (((1+Math.random())*0x10000)|0).toString(16).substring(1) + (((1+Math.random())*0x10000)|0).toString(16).substring(1)
			return guid

		# attempt to create an actor from the json packet, return a reference to the actor we created
		spawnActor: (actorType, options) ->
			a = @actorFactory(actorType, options)
			@actors.push a
			return a

		getActorByUID: (uid) ->
			a = _.find @actors, (actor) ->
				actor.id == uid
			if a then a else -1

		deleteActor: (actor) ->
			actor.remove()
			@world.removeBody(actor.body)	

		# loop through all actors and update each one
		update: () ->
			@world.update()
			# update all dynamic actors
			_.each @actors, (actor) =>	
				if actor.dynamic
					actor.update()
					if !actor.alive
						@deleteActor(actor)

			# filter our actor listing to get rid of dead guys
			@actors = _.filter @actors, (actor) ->
				actor.alive

	return Box2DActorManager