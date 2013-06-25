define [
	'vendor/underscore',
	'bin/EventDispatcher',
	'bin/Level',
	'bin/LevelBoxes'
	], (_, EventDispatcher, Level, LevelBoxes) ->

	class GameManager extends EventDispatcher

		constructor: (level) ->
			super

			# an array to hold all of our actors by id
			@currentLevel = []

			@ready = true

		# factory method, returns an Actor object based on criteria
		actorFactory: (actorType, options) ->
			switch(actorType)
				when "PlatformActor" then new PlatformActor(@generateUID(), options)
				when "ActorPixiHero" then new ActorPixiHero(@generateUID(), options)
				else new Actor(@generateUID(), options)

		# generate a guid for new actors
		generateUID: () ->
			guid = "d" + (((1+Math.random())*0x10000)|0).toString(16).substring(1) + (((1+Math.random())*0x10000)|0).toString(16).substring(1)
			return guid

		# attempt to create an actor from the json packet, return a reference to the actor we created
		getLevel: (levelName, options) ->
			a = @levelFactory(levelName, options)
			@currentLevel = a
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
			@level.update()

			# filter our actor listing to get rid of dead guys
			@actors = _.filter @actors, (actor) ->
				actor.alive

			game.log("Actors #{@actors.length}")

	return ActorManager