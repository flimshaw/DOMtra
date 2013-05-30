define [
	'vendor/underscore',
	'bin/EventDispatcher',
	'bin/Actor',
	'bin/PlatformActor',
	'bin/ActorPixiHero',
	], (_, EventDispatcher, Actor, PlatformActor, ActorPixiHero) ->

	class ActorManager extends EventDispatcher

		constructor: (level) ->
			super

			# save a reference to the game that created us
			@level = level

			# an array to hold all of our actors by id
			@actors = []

			@ready = true

		# factory method, returns an Actor object based on criteria
		actorFactory: (actorType, options) ->
			switch(actorType)
				when "Actor" then new Actor(@generateUID(), options)
				when "PlatformActor" then new PlatformActor(@generateUID(), options)
				when "ActorPixiHero" then new ActorPixiHero(@generateUID(), options)
				else new Actor(@generateUID(), options)

		# generate a guid for new actors
		generateUID: () ->
			guid = "d" + (((1+Math.random())*0x10000)|0).toString(16).substring(1) + (((1+Math.random())*0x10000)|0).toString(16).substring(1)
			return guid

		# attempt to create an actor from the json packet, return a reference to the actor we created
		spawnActor: (actor, options) ->
			if typeof actor == "string"
				a = @actorFactory(actor, options)
				@actors.push a
			else
				@actors.push new actor(@generateUID(), options)
			return actor

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

			game.log("Actors #{@actors.length}")

	return ActorManager