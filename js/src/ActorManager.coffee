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

	class ActorManager extends EventDispatcher

		constructor: (game) ->
			super
			
			# save a reference to the game that created us
			@game = game

			# an array to hold all of our actors by id
			@actors = []

		# factory method, returns an Actor object based on criteria
		actorFactory: (actorType, options) ->

			switch(actorType)
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

		# loop through all actors and update each one
		update: () ->
			# update all dynamic actors
			_.each @actors, (actor) =>	
				if actor.dynamic
					actor.update()
					if !actor.alive
						@deleteActor(actor)

			# filter our actor listing to get rid of dead guys
			@actors = _.filter @actors, (actor) ->
				actor.alive

	return ActorManager